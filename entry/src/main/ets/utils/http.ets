import axios, {
  AxiosError,
  AxiosInstance,
  AxiosRequestConfig,
  AxiosResponse,
  CreateAxiosDefaults,
  InternalAxiosRequestConfig
} from '@ohos/axios';
import { PicaResponse } from './model';
import { Ok, RequestMethod, StorageKey, Timeout, Unauthorized } from './consts';
import { HashMap } from '@kit.ArkTS';
import {
  Accept,
  Agent,
  Api,
  ApiKey,
  AppNonce,
  AppUuid,
  AppVersion,
  BuildVersion,
  Host,
  Platform,
  SecretKey
} from './config';
import { LogUtil, RandomUtil } from '@pura/harmony-utils';
import CryptoJS from '@ohos/crypto-js';
import { PreferenceStorageKey } from './preference';

export class HttpUtil {
  private static instance: AxiosInstance

  public static init() {
    HttpUtil.instance = axios.create(HttpUtil.defaultConfig());
    HttpUtil.httpInterceptorsRequest();
    HttpUtil.httpInterceptorsResponse();
  }

  public static request<T>(
    method: RequestMethod,
    url: string,
    config?: AxiosRequestConfig<ESObject>
  ): Promise<T> {
    if (config) {
      config.method = method
      config.url = url
    } else {
      config = { method, url }
    }
    return new Promise((resolve, reject) => {
      HttpUtil.instance
        .request(config)
        .then((response: ESObject) => {
          resolve(response);
        })
        .catch((error: AxiosError) => {
          reject(error);
        });
    });
  }

  public static get<T>(url: string, params?: ESObject): Promise<T> {
    return HttpUtil.request<T>('GET', url, { params });
  }

  public static post<T>(url: string, data?: ESObject): Promise<T> {
    return HttpUtil.request<T>('POST', url, { data });
  }

  private static defaultConfig(): CreateAxiosDefaults {
    return {
      baseURL: AppStorage.get(PreferenceStorageKey.Api),
      // 超时时间30秒
      timeout: 15 * 1000,
      headers: {
        'Accept': 'application/json, text/plain, */*',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      },
    }
  }

  private static buildHeader(path: string = '', method: string = 'GET'): HashMap<String, String> {
    const timestamp = (new Date().getTime() / 1000).toFixed(0);
    const nonce = RandomUtil.generateUUID32().toLowerCase().replace('-', '');

    const header = new HashMap<String, String>();
    header.set('Content-Type', 'application/json; charset=UTF-8');
    header.set('app-channel', AppStorage.get(PreferenceStorageKey.APP_CHANNEL));
    header.set('app-uuid', AppUuid);
    header.set('accept', Accept);
    header.set('app-platform', Platform);
    header.set('time', timestamp);
    header.set('nonce', nonce);
    header.set('image-quality', AppStorage.get(PreferenceStorageKey.IMAGE_QUALITY))
    header.set('signature', HttpUtil.createSignature(path, timestamp, nonce, method));
    if (AppStorage.get(PreferenceStorageKey.Api) === Api.Origin) {
      header.set('api-key', ApiKey);
      header.set('app-version', AppVersion);
      header.set('app-build-version', BuildVersion)
      header.set('app-nonce', AppNonce);
      header.set('User-Agent', Agent);
      header.set('Host', Host);
    }
    return header
  }

  private static createSignature(path: string, timestamp: string, nonce: string, method: string): string {
    if (path.startsWith('/')) {
      path = path.substring(1)
    }
    const raw = (path + timestamp + nonce + method + ApiKey).toLowerCase()
    LogUtil.debug(`SignRaw:   ${raw}`)
    const signature = CryptoJS.HmacSHA256(raw, SecretKey).toString(CryptoJS.enc.Hex)
    LogUtil.info(`Signature: ${signature}`)
    return signature;
  }

  /**请求拦截器*/
  private static httpInterceptorsRequest() {
    HttpUtil.instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      // 对请求数据做点什么
      config.headers[StorageKey.TOKEN] = AppStorage.get(StorageKey.TOKEN)
      HttpUtil.buildHeader(config.url, config.method).forEach((val: string, key: string) => {
        config.headers[key] = val
      })
      LogUtil.debug(`Host: ${AppStorage.get(PreferenceStorageKey.Api)}`)
      LogUtil.debug(`接口[${config.url}]发送请求，请求参数：${JSON.stringify(config.params)}，请求体：${JSON.stringify(config.data)}`)
      return config;
    }, (error: AxiosError) => {
      // 对请求错误做些什么
      LogUtil.error(error.message)
      return Promise.reject(error);
    });
  }

  /**响应拦截器*/
  private static httpInterceptorsResponse() {
    HttpUtil.instance.interceptors.response.use((response: AxiosResponse<PicaResponse<ESObject>, ESObject>) => {
      // 对响应数据做点什么
      if (response.status === Ok) {
        LogUtil.debug(`接口[${response.config.url}]请求成功，返回结果：${JSON.stringify(response.data)}`)
        return response.data.data
      } else if (response.status === Unauthorized) {
        return Promise.reject(new Error(`${Unauthorized}`));
      } else {
        return Promise.reject(`${response.data.error}: ${response.data.message}`);
      }
    }, (error: AxiosError<PicaResponse<ESObject>, ESObject>) => {
      // 对响应错误做点什么
      if (error.message.toLowerCase().includes(Timeout)) {
        LogUtil.error(`接口请求失败：连接超时`)
        return Promise.reject(new Error(Timeout));
      } else {
        if (error.response) {
          if (typeof error.response.data === 'string') {
            LogUtil.error(`接口[${error.response.config.url}]请求异常：${error.response.data}`)
            return Promise.reject(error);
          }
          if (error.response.data.code === Unauthorized) {
            LogUtil.error(`接口[${error.response.config.url}]请求失败：Unauthorized`)
            return Promise.reject(new Error(`${Unauthorized}`));
          }
          LogUtil.error(`接口[${error.response.config.url}]请求失败：${error.response.data?.message}`)
          return Promise.reject(new Error(`${error.response.data.error}: ${error.response.data?.message}`));
        } else {
          LogUtil.error(`接口请求异常：${error.message}`)
          return Promise.reject(error);
        }
      }
    });
  }
}