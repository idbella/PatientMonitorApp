
class Insurance{
	int id;
	String title;
	Insurance(this.id,this.title);

	static Insurance fromJson(var json)
	{
		Insurance insurance = Insurance(
			json['id'],
			json['title']
		);
		return insurance;
	}
}
