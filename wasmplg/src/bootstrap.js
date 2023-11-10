async function wasmplg() {
    const obj = await WebAssembly.instantiateStreaming(fetch('wasmplg.wasm'), {});
    const wasm = obj.instance.exports;

    console.log(wasm.factorial(6));
    console.log(wasm.multiply(4, 5));
}

wasmplg();
