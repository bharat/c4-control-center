function onDataToUi(value) {
    console.log("DATA_TO_UI: " + value);
    var response = JSON.parse(value);
    if (response == null) {
        console.log("DATA_TO_UI: onDataToUi called with invalid or no JSON")
        return;
    }
    console.log("DATA_TO_UI: successfully parsed response.")

    if ("devicecommand" in response) {
	if (response.devicecommand.command == "SET_ENTRY") {
	    var param = response.devicecommand.params.param.reduce((acc, p) => {
		acc[p.name] = p.value.static;
		return acc;
	    }, {});
	    SetEntry(param.id, param.title, param.status, param.state);
	}
    }
}

function onVariable(value) {
    console.log("Received variable: " + value);
}

function onSendCommandError(message) {
    console.log("Error sending command: " + message);
}

function onSubscribeToDataToUiError(message) {
    console.log("Error subscribing to data to ui: " + message);
}

function onSubscribeToVariableError(variable, message) {
    console.log("Error subscribing to variable: " + variable + "," + message);
}

function SetEntry(id, title, status, state) {
    console.log("SetEntry(" + id + ", " + title + ", " + status + ", " + state + ")");

    $("#entry-" + id).remove();
    var img_attrs = (() => {
	switch(state) {
	case "OK":
	    return { src: "Check_180.png", class: "filter-green" };
	case "ERROR":
	    return { src: "Alert_180.png", class: "filter-red" };
	default:
	    return {}
	}
    })();
    $("#entries").append(
	$("<div/>", { id: "entry-" + id, class: "entry" })
	    .append($("<div/>", { class: "title" }).text(title))
	    .append($("<div/>", { class: "status" }).text(status))
	    .append($("<div/>", { class: "image" }).append(
		$("<img/>", img_attrs)
	    ))
    );
}

function RequestUpdate() {
    C4.sendCommand('Request Update', '{}', true, true);
}

function RefreshData() {
    var url = window.location.href.split('?')[0];
    location.href = url + "?t=" + Date.now();
}

function init() {
    C4.sendCommand("GetState", "", false, false);
    C4.subscribeToDataToUi(true);

    RequestUpdate();
}

$(document).ready(dev_init);
$(document).ready(init);


// --------------------------------------------------------------------------------
// Utilities
// --------------------------------------------------------------------------------

// Create a fake C4 API implementation so that we can rapidly test functionality in a
// web browser.
function dev_init() {
    if ("C4" in window) {
	return;
    }

    C4 = {
	sendCommand: function(commandName, params, asyncMode, sendToProtocol) {
	    switch (commandName) {
	    case "GetState":
		onDataToUi(JSON.stringify({
		    "result": 1,
		    "seq": "<fake seq>",
		    "state": {
			"icon_description": "",
			"icon": "default",
		    },
		    "name": "SendToDevice",
		}))
		break;

	    case "Request Update":
		// Populate the UI with some fake data
		[["occupancy", "Occupancy", "Home", "OK"],
		 ["alarm", "Alarm", "Armed (Stay)", "OK"],
		 ["doors", "Doors", "Three doors unlocked", "ERROR"],
		 ["heat", "Heat", "All thermostats synced", "OK"]].forEach(param => {
		     onDataToUi(JSON.stringify({
			 devicecommand: {
			     command: "SET_ENTRY",
			     params: {
				 param: [
				     // param order is not guaranteed
				     { name: "id", value: { type: "string", static: param[0] } },
				     { name: "title", value: { type: "string", static: param[1] } },
				     { name: "status", value: { type: "string", static: param[2] } },
				     { name: "state", value: { type: "string", static: param[3] } },
				 ],
			     },
			 }
		     }));
		 })
		break;
	    }
	},
	subscribeToDataToUi: function() { },
	subscribeToVariable: function() { }
    }
}

function browser_diagnostics() {
    console.log("Window dimensions: [" + window.screen.width + "x" + window.screen.height + "]");
    console.log("User agent: " + navigator.userAgent);
}
