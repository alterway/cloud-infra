var AWS = require('aws-sdk');
exports.handler = (event, context, callback) => {
    var paramsGet = {
        name: "$PIPELINE_NAME"
    };
    var codepipeline = new AWS.CodePipeline();
    codepipeline.getPipelineState(paramsGet, function(err, data) {
        if (err) console.log(err, err.stack);
        else {
            if (data.stageStates.length > 0) {
            var token = null;
            for (let stage of data.stageStates) {
                var stageName = stage.stageName;
                if (stageName === "$STAGE_NAME") {
                    var actionStates = stage.actionStates;
                    for (let actionState of actionStates) {
                        var actionName = actionState.actionName;
                        if (actionName === "$APPROVAL_NAME") {
                            token = actionState.latestExecution.token;
                            break;
                        }
                    }
                }
            }
            var paramsPut = {
                actionName: "$APPROVAL_NAME",
                pipelineName: "$PIPELINE_NAME",
                result: {
                    status: "Approved",
                    summary: "Scheduled approval by Lambda."
                },
                stageName: "$STAGE_NAME",
                token: token
            };
            if (token != null) {
            codepipeline.putApprovalResult(paramsPut, function(err, data) {
                if (err) console.log(err, err.stack);
                else console.log(data);
            });
            }
        }
    }
        callback(null, "Approved");

    })
};
