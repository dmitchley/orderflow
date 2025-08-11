import { LightningElement, api, wire } from "lwc";
import getSessionsByEvent from "@salesforce/apex/SessionService.getSessionsByEvent";

const COLUMNS = [
    { label: "Session Name", fieldName: "Name" },
    { label: "Start Time", fieldName: "Starting_Time__c", type: "date" },
    { label: "End Time", fieldName: "Ending_Time__c", type: "date" },
    { label: "Max Capacity", fieldName: "Max_Capacity__c", type: "number" },
    { label: "Location", fieldName: "Location__r.Name" },
    { label: "Speaker", fieldName: "Speaker__r.Name" }
];

export default class SessionList extends LightningElement {
    @api recordId; // This will be the Event Id if placed on Event record page
    sessions;
    error;
    columns = COLUMNS;

    @wire(getSessionsByEvent, { eventId: "$recordId" })
    wiredSessions({ data, error }) {
        if (data) {
            this.sessions = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.sessions = undefined;
        }
    }
}