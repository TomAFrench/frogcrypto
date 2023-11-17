const { EdDSAFrogPCDPackage } = require("@pcd/eddsa-frog-pcd");
const { fromHexString } = require("@pcd/util");
const { buildEddsa } = require("circomlibjs");

const { init, deserialize } = EdDSAFrogPCDPackage;

async function main() {
  await init({})
  const eddsa = await buildEddsa();

  // Burner frog as used in nargo test
  const frogEddsaPCD = {
    "type":"eddsa-frog-pcd",
    "pcd":"{\"id\":\"63ce5b7c-96f2-4499-bcdc-f578d0dacbf1\",\"eddsaPCD\":{\"type\":\"eddsa-pcd\",\"pcd\":\"{\\\"type\\\":\\\"eddsa-pcd\\\",\\\"id\\\":\\\"d850b696-ea96-4ed4-81c2-3e3e02cad319\\\",\\\"claim\\\":{\\\"message\\\":[\\\"a\\\",\\\"3\\\",\\\"1\\\",\\\"b\\\",\\\"3\\\",\\\"3\\\",\\\"3\\\",\\\"5\\\",\\\"18bdea9b454\\\",\\\"17c334f4343c632f8a50e01f1f460177ccb0e137390283c4e799201c3d62e38c\\\",\\\"0\\\",\\\"0\\\",\\\"0\\\"],\\\"publicKey\\\":[\\\"0f183dcba06341a4549d78c3f8ca0060a9d6aca795103cb6957d1e2973b5fdeb\\\",\\\"2a2eb70efeebb5facca2f3668ca5642513be542bab285055ccdcbc18cc125fd5\\\"]},\\\"proof\\\":{\\\"signature\\\":\\\"14bff8bb8588c4c0fa503d2faa0cf330dc2578b35a86b02453a15f6f7892ba800a0efe3db99b3f17ad42114483e8a8cf45686cf35a336d65dd07f01f145a9c02\\\"}}\"},\"data\":{\"name\":\"Budgett’s Frog\",\"description\":\"Budgett's frog, named after British zoologist Samuel Budgett, is a peculiar frog species found in South America, particularly in Bolivia and Paraguay. Known for its flattened body, large mouth, and unique appearance, these frogs are often referred to as \\\"Paraguay horned frogs\\\" due to the horn-like projections on their eyelids.\",\"imageUrl\":\"https://api.zupass.org/frogcrypto/images/aab6a86e-c221-498b-93f5-6698b2460758\",\"frogId\":10,\"biome\":3,\"rarity\":1,\"temperament\":11,\"jump\":3,\"speed\":3,\"intelligence\":3,\"beauty\":5,\"timestampSigned\":1700247745620,\"ownerSemaphoreId\":\"10748096169585012891334706690982223299749822368867987828636352599303890592652\"}}"
  };
  const my_frog = await deserialize(frogEddsaPCD.pcd);


  const pubkey = my_frog.proof.eddsaPCD.claim.publicKey;
  const rawSig = eddsa.unpackSignature(
    fromHexString(my_frog.proof.eddsaPCD.proof.signature)
  );
  const frogSignatureR8x = eddsa.F.toObject(rawSig.R8[0]).toString();
  const frogSignatureR8y = eddsa.F.toObject(rawSig.R8[1]).toString();
  const frogSignatureS = rawSig.S.toString();

  console.log(my_frog.claim.data)
  console.log(pubkey[0])
  console.log(pubkey[1])
  console.log(frogSignatureR8x)
  console.log(frogSignatureR8y)
  console.log(frogSignatureS)
}

main()