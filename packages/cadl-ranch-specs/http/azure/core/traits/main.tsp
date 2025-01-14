import "@azure-tools/typespec-azure-core";
import "@azure-tools/cadl-ranch-expect";
import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";

using global.Azure.Core;
using global.Azure.Core.Traits;
using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;

#suppress "@azure-tools/typespec-azure-core/casing-style" "For spec"
@doc("Illustrates Azure Core operation customizations by traits")
@scenarioService(
  "/azure/core/traits",
  {
    versioned: Versions,
  }
)
@versioned(Versions)
namespace _Specs_.Azure.Core.Traits;

enum Versions {
  @useDependency(global.Azure.Core.Versions.v1_0_Preview_2)
  v2022_12_01_preview: "2022-12-01-preview",
}

alias ServiceTraits = SupportsRepeatableRequests & SupportsConditionalRequests & SupportsClientRequestId;

alias OperationsWithTraits = global.Azure.Core.ResourceOperations<ServiceTraits>;

@doc("Sample Model")
@resource("user")
model User {
  @key
  @doc("The user's id.")
  @visibility("read")
  id: int32;

  @doc("The user's name.")
  name?: string;
}

@scenario
@doc("Get a resource, sending and receiving headers.")
@scenarioDoc("""
Expected path parameter: id=1
Expected query parameter: api-version=2022-12-01-preview
Expected header parameters:
- foo=123
- if-match=valid
- if-none-match=invalid
- if-unmodified-since=Fri, 26 Aug 2022 14:38:00 GMT
- if-modified-since=Thu, 26 Aug 2021 14:38:00 GMT
- x-ms-client-request-id=<any string>

Expected response header: x-ms-client-request-id=<any string>
Expected response body:
```json
{
  "id": 1,
  "name": "Madge",
  "etag": "11bdc430-65e8-45ad-81d9-8ffa60d55b59"
}
```
""")
op smokeTest is OperationsWithTraits.ResourceRead<
  User,
  RequestHeadersTrait<{
    @doc("header in request")
    @header
    foo: string;
  }> &
    ResponseHeadersTrait<{
      @header bar: string;
    }>
>;
