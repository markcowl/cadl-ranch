import { RequestExpectation } from "./expectation.js";
import { RequestExt } from "./types.js";

export class MockRequest {
  public readonly expect: RequestExpectation;

  public readonly baseUrl: string;
  public readonly headers: { [key: string]: string };
  public readonly query: { [key: string]: string | string[] };
  public readonly params: { [key: string]: string };
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  public readonly body: any;

  public constructor(public originalRequest: RequestExt) {
    this.baseUrl = getRequestBaseUrl(originalRequest);
    this.expect = new RequestExpectation(originalRequest);
    this.headers = originalRequest.headers as { [key: string]: string };
    this.query = originalRequest.query as { [key: string]: string };
    this.params = originalRequest.params as { [key: string]: string };
    this.body = originalRequest.body;
  }
}

const getRequestBaseUrl = (request: RequestExt): string => `${request.protocol}://${request.get("host")}`;
