import './state.dart';
import './action.dart';

bool checkSameId (a, b) {
  return a['id'] == b['id'];
}

List<dynamic> combinLyric (String source) {
  List<dynamic> outputLyric = [];
  source.split('[').forEach((item) {
    List<String> splitItem = item.split('');
    // 需要保证歌词进度是正确的格式
    bool isAccess = true;
    try {
      int.parse(splitItem[0] + splitItem[1]);
    } catch (err) {
      isAccess = false;
    }
    if (isAccess) {
      outputLyric.add(item.split(']'));
    }
  });
  return outputLyric;
}

PlayController playControllerReducer(PlayController state, action) {
  if(action != null) {
    if (action['type'] == Actions.nextSong || action['type'] == Actions.prevSong
    || action['type'] == Actions.addPlayList) {
      state.coverMainColor = action['payload']['coverMainColor'];
    }
    if (action['type'] == Actions.changeProgress) {
      state.songProgress = action['payload'];
    }
    if (action['type'] == Actions.play) {
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
    if (action['type'] == Actions.pause) {
      state.audioPlayer.pause();
      state.playing = false;
    }
    if (action['type'] == Actions.nextSong) {
      if (state.playing) {
        state.audioPlayer.stop();
      }
      if (action['payload']['songUrl'] == null) {
        state.playing = false;
        state.songIndex = state.songIndex + 1;
        state.currentIndex = state.currentIndex + 1;
        state.songUrl = 'http://music.163.com/song/media/outer/url?id=' + state.songList[state.songIndex + 1] + '.mp3';
        state.audioPlayer.play(state.songUrl);
        state.playing = true;
      } else {
        if (action['payload']['songDetail']['songLyr']['lrc'] != null && action['payload']['songDetail']['songLyr']['lrc']['lyric'] != null) {
          action['payload']['songDetail']['lyric'] = combinLyric(action['payload']['songDetail']['songLyr']['lrc']['lyric']);
        }
        state.playing = false;
        state.songIndex = state.songIndex + 1;
        state.playList.add(action['payload']['songDetail']);
        state.currentIndex = state.currentIndex + 1;
        state.songUrl = action['payload']['songUrl'];
        state.audioPlayer.play(state.songUrl);
        state.playing = true;
      }
    }
    if (action['type'] == Actions.prevSong) {
      if (state.playing) {
        state.audioPlayer.stop();
      }
      if (action['payload']['songDetail']['songLyr']['lrc'] != null && action['payload']['songDetail']['songLyr']['lrc']['lyric'] != null) {
        action['payload']['songDetail']['lyric'] = combinLyric(action['payload']['songDetail']['songLyr']['lrc']['lyric']);
      }
      state.playing = false;
      state.songIndex = state.songIndex - 1;
      state.currentIndex = state.currentIndex - 1;
      state.songUrl = action['payload']['songUrl'];
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
    if(action['type'] == Actions.addPlayList) {
      if (state.playing) {
        state.audioPlayer.stop();
        state.playing = false;
      }
      if (action['payload']['songList'] != null) {
        state.songList = action['payload']['songList'];
      }
      if (action['payload']['songDetail']['songLyr']['lrc'] != null && action['payload']['songDetail']['songLyr']['lrc']['lyric'] != null) {
        action['payload']['songDetail']['lyric'] = combinLyric(action['payload']['songDetail']['songLyr']['lrc']['lyric']);
      }
      state.songIndex = action['payload']['songIndex'];
      state.playList.add(action['payload']['songDetail']);
      state.currentIndex = state.playList.length - 1;
      state.songUrl = action['payload']['songUrl'];
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
    if (action['type'] == Actions.playSeek) {
      if(action['payload'] != null) {
        print(action['payload']);
        state.audioPlayer.seek(action['payload']);
      }
    }
    if (action['type'] == Actions.switchSongComments) {
      print('success');
      state.showSongComments = !state.showSongComments;
    }
    if (action['type'] == Actions.addCollectSong) {
      dynamic newSongMap = {};
      if (state.collectSongs.length > 0) {
        bool findSameSongFlag = state.collectSongs.any((item) => checkSameId(item, state.playList[state.currentIndex]));
        if (!findSameSongFlag) {
          newSongMap['id'] = state.playList[state.currentIndex]['id'];
          newSongMap['songUrl'] = state.songUrl;
          newSongMap['cover'] = state.playList[state.currentIndex]['al']['picUrl'];
          newSongMap['name'] = state.playList[state.currentIndex]['name'];
          newSongMap['author'] = state.playList[state.currentIndex]['ar'][0]['name'];
          state.collectSongs.add(newSongMap);
        }
      } else {
        newSongMap['id'] = state.playList[state.currentIndex]['id'];
        newSongMap['songUrl'] = state.songUrl;
        newSongMap['cover'] = state.playList[state.currentIndex]['al']['picUrl'];
        newSongMap['name'] = state.playList[state.currentIndex]['name'];
        newSongMap['author'] = state.playList[state.currentIndex]['ar'][0]['name'];
        state.collectSongs.add(newSongMap);
      }
    }
  }
  return state;
}