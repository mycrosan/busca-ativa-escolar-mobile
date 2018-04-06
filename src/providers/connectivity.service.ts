import {Injectable, Pipe, PipeTransform} from "@angular/core";
import {Connection} from "../declarations";

@Injectable()
export class ConnectivityService {

	isForcedOffline = false;
	currentCallback = null;
	currentStatus = false;
	timer = null;
	onlineStatuses = [];

	constructor() {

	}

	setup() {

		if(navigator.connection) {
			this.onlineStatuses = [
				/*Connection.ETHERNET,
				Connection.WIFI,
				Connection.CELL_2G,
				Connection.CELL_3G,
				Connection.CELL_4G,
				Connection.CELL,
				Connection.UNKNOWN*/
				'ethernet',
				'wifi',
				'cell',
				'cell_2g',
				'cell_3g',
				'cell_4g',
				'2g',
				'3g',
				'4g',
				'unknown'
			];
		}

		let status = this.isOnline();

		console.log("[connectivity] Valid online statuses: ", this.onlineStatuses.join(", "));
		console.log("[connectivity] Initial network status: ", (status ? 'ONLINE' : 'OFFLINE'), (navigator.connection ? navigator.connection.type : 'UNKOWN_DESKTOP'));

		this.timer = setInterval(() => {
			this.checkConnectionStatus();
		}, 500);
	}

	checkConnectionStatus() {
		let status = this.isOnline();

		if(status !== this.currentStatus) {
			console.log("[connectivity] Network status changed to: ", (status ? 'ONLINE' : 'OFFLINE'), (navigator.connection ? navigator.connection.type : 'UNKOWN_DESKTOP'));
			if(this.currentCallback) this.currentCallback(status);
		}

		this.currentStatus = status;
	}

	isForcedOfflineActive():boolean {
		return this.isForcedOffline;
	}

	setForcedOffline(isOffline:boolean) : void {
		this.isForcedOffline = isOffline;
	}

	isOnline():boolean {

		if(this.isForcedOffline) {
			return false;
		}

		if(navigator.connection) {
			return (this.onlineStatuses.indexOf(navigator.connection.type) !== -1);
		}

		return navigator.onLine;
	}

	onStatusChange(callback) {
		console.log("[connectivity] Set change callback: ", callback);
		this.currentCallback = callback;
	}

}