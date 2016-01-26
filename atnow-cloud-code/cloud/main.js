
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("Notification", function(request, response){
	var notification = request.object;
	var owner = notification.owner
	var query = new Parse.Query(Parse.Installation);
	query.equalTo('user', owner);

	Parse.Push.send({
  	where: query, // Set our Installation query
  	data: {
    	alert: "This is a test notification" 
  	}
	}, {
  	success: function() {
    	// Push was successful
			print("Push was sent succesfully");
  	},
  	error: function(error) {
   	  // Handle error
			print("Push was sent succesfully");

 	 }
	});
});
