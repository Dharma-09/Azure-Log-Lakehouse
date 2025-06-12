import logging
import azure.functions as func
import json
from datetime import datetime

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        log = req.get_json()
        cloud = log.get("cloud")

        if cloud == "aws":
            normalized = {
                "timestamp": log["eventTime"],
                "cloud": "aws",
                "user": log["userIdentity"]["userName"],
                "action": log["eventName"],
                "resource": log.get("requestParameters", {}).get("bucketName", "unknown"),
                "source_ip": log["sourceIPAddress"]
            }

        elif cloud == "gcp":
            normalized = {
                "timestamp": log["timestamp"],
                "cloud": "gcp",
                "user": log["protoPayload"]["authenticationInfo"]["principalEmail"],
                "action": log["protoPayload"]["methodName"],
                "resource": log["resource"]["name"],
                "source_ip": log["protoPayload"]["requestMetadata"]["callerIp"]
            }

        elif cloud == "azure":
            normalized = {
                "timestamp": log["time"],
                "cloud": "azure",
                "user": log["caller"],
                "action": log["operationName"],
                "resource": log["resourceId"],
                "source_ip": log.get("properties", {}).get("ipAddress", "unknown")
            }

        else:
            return func.HttpResponse("Unsupported cloud provider", status_code=400)

        return func.HttpResponse(json.dumps(normalized), mimetype="application/json")

    except Exception as e:
        logging.error(str(e))
        return func.HttpResponse("Error processing log", status_code=500)
