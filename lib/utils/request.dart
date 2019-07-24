import 'dart:io';
import 'dart:convert';

dynamic fetchData(String url) async {
  print('request start');
  String responeseBody;
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(
    Uri.parse(url)
  );
  HttpClientResponse response = await request.close();
  if (response.statusCode == 200) {
    responeseBody = await response.transform(utf8.decoder).join();
    responeseBody = await jsonDecode(responeseBody);
    print('responeseBody =====>');
    print(responeseBody);
    print('====================');
    return responeseBody;
  } else {
    print('请求错误');
    return '请求错误';
  }
}