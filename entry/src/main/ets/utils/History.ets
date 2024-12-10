import { KvUtil } from '@pura/harmony-utils';
import { ComicDetailInfo } from '../api/models';
import { JSON } from '@kit.ArkTS';
import { StorageKey } from '../common/Consts';

export class HistoryUtil {
  public static add(comic: ComicDetailInfo) {
    KvUtil.put(comic._id, JSON.stringify(comic)).then(() => {
      let hisIds = AppStorage.get<string[]>(StorageKey.HISTORY)
      if (hisIds && hisIds.indexOf(comic._id) < 0) {
        hisIds.push(comic._id)
      } else {
        hisIds = [comic._id]
      }
      AppStorage.setOrCreate<string[]>(StorageKey.HISTORY, hisIds)
    })
  }

  public static get() {
    let hisIds = AppStorage.get<string[]>(StorageKey.HISTORY)
    if (hisIds && hisIds.length !== 0) {
      let comics: ComicDetailInfo[] = []
      hisIds.forEach(async (id) => {
        comics.push(JSON.parse(await KvUtil.getString(id)) as ComicDetailInfo)
      })
      return comics
    } else {
      return []
    }
  }

  public static clear() {
    let hisIds = AppStorage.get<string[]>(StorageKey.HISTORY)
    if (hisIds) {
      KvUtil.deleteBatch(hisIds)
      AppStorage.set<string[]>(StorageKey.HISTORY, hisIds)
    }
  }
}