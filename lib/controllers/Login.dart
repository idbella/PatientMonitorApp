
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:requests/requests.dart';

Future<Response> authenticate(String email, String password){

	print('login $email $password');
	
	return Requests.post(
		Globals.url + '/api/login',
		body: {
			'email': email,
			'password': password
		}
	);
}
