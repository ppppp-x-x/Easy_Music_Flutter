import './request.dart';

dynamic getSongDetail(int id) async {
  dynamic _songDetail = await fetchData('http://xinpeng.natapp1.cc/song/detail?ids=' + id.toString());
  return _songDetail['songs'][0];
}