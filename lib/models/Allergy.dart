
class Allergy{

	String		title;
	String		description;
	
	Allergy(this.title,this.description);

	static Allergy fromJson(Map<String, dynamic> json){ 
		Allergy allergy = Allergy(json['title'],json['description']);
		return allergy;
	}
}
