import 'package:get/get.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleDriveController extends GetxController {
  List<String> folderId = ['root'];

  GoogleSignIn _googleSignIn =
      GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);

  var filesList = <drive.File>[].obs;
  var loading = false.obs;
  var loadingForPageToken = false.obs;
  var pagenTok;

  @override
  void onInit() async {
    await _handleSignIn();

    getFiles();

    super.onInit();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  void getFiles() async {
    if(pagenTok == null){
      loading.value = true;
    } else {
      loadingForPageToken.value = true;
    }

    print('PageToken: $pagenTok');
    print('PageId: ${folderId.last}');

    GoogleSignInAccount? account = await _googleSignIn.signIn();

    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    var list = await driveApi.files.list(
        q: "'${folderId.last}' in parents",
        spaces: "drive",
        orderBy: 'folder,modifiedTime desc',
        pageToken: pagenTok,

        $fields: "nextPageToken, files("
            "id, "
            "name, "
            "mimeType, "
            "webViewLink, "
            "webContentLink, "
            "imageMediaMetadata, "
           "thumbnailLink, "
            "createdTime)"
    );


    pagenTok = list.nextPageToken;

    print('PagToke $pagenTok');


    list.files!.forEach((element) {
      filesList.add(element);
    });

    filesList.refresh();
    loading.value = false;
    loadingForPageToken.value = false;
  }

  String getMimeType(String mimeType) {
    if(mimeType == 'application/vnd.google-apps.folder'){
      return 'folder';
    } else if(mimeType == 'audio/mp3' ||
        mimeType == 'audio/x-flac' ||
        mimeType == 'audio/flac' ||
        mimeType == 'audio/mpeg') {
      return 'audio';
    }
    else {
      return '';
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
