
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
	response.success("Hello world!");
});

Parse.Cloud.afterSave("Notification", function(request, response){
	var notification = request.object;
	console.log(notification);
	var userQuery = new Parse.Query(Parse.User);
	console.log(notification.get('owner'));
	userQuery.equalTo('objectId', notification.get('owner').id);
	userQuery.first({
		success: function(object) {
    		// Successfully retrieved the object.
    		var owner = object;
    		var query = new Parse.Query(Parse.Installation);
    		query.equalTo('user', owner);
    		Parse.Push.send({
				where: query, // Set our Installation query
				data: {
					alert: notification.get("message")
				}
		}	, {
			success: function() {
				// Push was successful
				console.log("Push was sent succesfully");
			},
			error: function(error) {
				// Handle error
				console.log("Push was sent succesfully");

			}
		});
    },
    error: function(error) {
    	alert("Error: " + error.code + " " + error.message);
    	}
	});	
});
