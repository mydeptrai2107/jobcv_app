const uriApiApp = "http://192.168.2.16:8080/";
const kImageDefault =
    'https://images.unsplash.com/photo-1661956602153-23384936a1d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80';
//const uriApiApp = "https://ec16-116-98-51-96.ngrok-free.app/";
const kSaveRecently = 'save_recently';

const String urlAvatarUser = '${uriApiApp}static/cv/';
const String urlAvatarCompany = '${uriApiApp}static/image/';

String getAvatarUser(String image) {
  return image == ''
      ? '${uriApiApp}static/image/user.png'
      : urlAvatarUser + image;
}

String getAvatarCompany(String image) {
  return image == ''
      ? '${uriApiApp}static/image/user.png'
      : urlAvatarCompany + image;
}
