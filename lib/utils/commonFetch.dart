import './request.dart';
import './url.dart';

dynamic getSongDetail(int id) async {
  dynamic _songDetail = await fetchData(localBaseUrl + 'song/detail?ids=' + id.toString());
  return _songDetail['songs'][0];
}