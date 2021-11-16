


class CustomerData {

  final String u_username;
  final String ca_email;
  final String ca_phone;
  final String user_id;
  final String ca_name;
  final String ca_address1;
  final String ca_address2;
  final String ca_pos;
  final String ca_city;
  final String ca_state;
  final String ca_country;
  final String u_lastupdate;
  final String ca_status;
  final String u_loginid;
  final String forgot_passord ;

  CustomerData(this.u_username, this.ca_email, this.ca_phone, this.user_id, this.ca_name, this.ca_address1, this.ca_address2, this.ca_pos, this.ca_city, this.ca_state, this.ca_country, this.u_lastupdate, this.ca_status, this.u_loginid, this.forgot_passord);


//  CustomerData(this.name, this.email,this.id,this.password);

  CustomerData.fromJson(Map<String, dynamic> json)
      : u_username = json['u_username'],
        ca_email = json['ca_email'],
        ca_phone =json['ca_phone'],
        user_id = json['user_id'],
        ca_name = json['ca_name'],
        ca_address1 = json['ca_address1'],
        ca_address2 = json['ca_address2'],
        ca_pos = json['ca_pos'],
        ca_city = json['ca_city'],
        ca_state = json['ca_state'],
        ca_country = json['ca_country'],
        u_lastupdate = json['u_lastupdate'],
        ca_status = json['ca_status'],
        forgot_passord = json['forgot_passord'],
        u_loginid = json['u_loginid'];

  Map<String, dynamic> toJson() => {
    'u_username': u_username,
    'ca_email': ca_email,
    'ca_phone': ca_phone,
    'user_id': user_id,
    'ca_name': ca_name,
    'ca_address1': ca_address1,
    'ca_address2': ca_address2,
    'ca_pos' : ca_pos,
    'ca_city': ca_city,
    'ca_state': ca_state,
    'ca_country': ca_country,
    'u_lastupdate': u_lastupdate,
    'ca_status': ca_status,
    'u_loginid': u_loginid,
    'forgot_passord':forgot_passord,
  };

  Map<String,dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["u_username"] = u_username;
    map["ca_email"] = ca_email;
    map["ca_phone"] = ca_phone;
    map["user_id"] = user_id;
    map["ca_name"] = ca_name;
    map["ca_address1"] = ca_address1;
    map["ca_address2"] = ca_address2;
    map["ca_city"] = ca_city;
    map["ca_state"] = ca_state;
    map["ca_country"] = ca_country;
    map["u_lastupdate"] = u_lastupdate;
    map["ca_status"] = ca_status;
    map["u_loginid"] = u_loginid;
    map["ca_pos"] = ca_pos;
    map["forgot_passord"] = forgot_passord;
    // Add all other fields
    return map;
  }

}


