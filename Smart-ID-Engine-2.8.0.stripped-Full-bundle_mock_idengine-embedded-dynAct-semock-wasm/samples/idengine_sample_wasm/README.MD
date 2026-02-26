# Smart Engines Idengine Wasm Sample

## How to start sample

1. Open `worker.js` and set `ENGINE_CONFIG.signature` and document mask `ENGINE_CONFIG.docTypes`.

```js
const ENGINE_CONFIG = {
  activationUrl: 'https://localhost:8000/client/sign_message',
  docTypes: 'mrz.*', // <- set document mask
  signature: '', // <-- set signature
};
```

2. Run `wasm_sample_server.py` from the root of SDK.
3. Open <https://localhost:4443/samples/idengine_sample_wasm/sample.html> and accept self-signed certificate.
4. Run activation server sample from Activation Tool SDK (for example, `https_activation_server_java`). Open <https://localhost:8000/client/sign_message> to accept self-signed certificate.

If you have a problem accepting self-signed certificate in Google Chrome, you can print directly to window `thisisunsafe`.

## Exceptions

To convert wasm exception to readable text format, please use `SE.printExceptionMessage(e)`:

```js
try {
  spawnedSession = engine.SpawnSession(sessionSettings, ENGINE_CONFIG.signature);
} catch (e) {
  console.error('Error :', SE.printExceptionMessage(e));
}
```

## Dependencies

- `wasm-feature-detect.js`
  License Apache-2.0
  <https://github.com/GoogleChromeLabs/wasm-feature-detect>

## Server requirements

1. **Content-type**. Web server MUST properly serve the `.wasm` file with HTTP response header `Content-Type: application/wasm`.
2. **Compression**. Web server must support wasm compression. This significantly speeds up wasm file download times.
   - Check the `content-encoding` response header from the `*.wasm` file in devtools.
   - Or check it with `curl -H "Accept-Encoding: gzip" -I https://*.wasm`
   More info: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding>
3. **Cross-Origin-Policy**. For multi-thread bundle you need to set up server COOP and COEP headers.
   More info: <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer#security_requirements>
4. **Precompress wasm files**
   You can compress the wasm files yourself so that you don't have to load the server with every request.

   How to configure nginx:
   <https://docs.unity3d.com/2023.1/Documentation/Manual/webgl-server-configuration-code-samples.html>
