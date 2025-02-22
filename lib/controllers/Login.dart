
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

Future<ResponseX> authenticate(String email, String password){
	
	return Requests.post(
		Globals.url + '/api/login',
		body: {
			'email': email,
			'password': password
		}
	);
}
