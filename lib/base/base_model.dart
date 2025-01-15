

class BaseModel {

   String QDString(dynamic t){
    if(t == null) {
      return "";
    }
    if(t is int || t is double){
      return t.toString().isEmpty ? "0" : t.toString();
    }else if(t is String){
      return t;
    }
    return t;
  }


}