/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * trufflesuite.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like @truffle/hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

// const HDWalletProvider = require('@truffle/hdwallet-provider');
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();

const { pkh, mnemonic, email, password, amount, activation_code} = require("./hangzhounet.json");

module.exports = {
  // see <https://trufflesuite.com/docs/tezos/truffle/reference/configuring-tezos-projects>
  // for more details on how to specify configuration options!
  networks: {
    development: {
      host: "https://127.0.0.1",
      port: 8732,
      network_id: "*",
      pkh,
      mnemonic,
      email,
      password,
      activation_code,
      type: "tezos"
    }
  }
};


// module.exports = {
//   networks: {
//     development: {
//       host: "localhost",
//       port: 8545,
//       network_id: "*" // Match any network id
//     },
//     ropsten: {
//       // must be a thunk, otherwise truffle commands may hang in CI
//       provider: () =>
//         new HDWalletProvider({
//           mnemonic: {
//             phrase: mnemonicPhrase
//           },
//           providerOrUrl: "https://ropsten.infura.io/v3/YOUR-PROJECT-ID",
//           numberOfAddresses: 1,
//           shareNonce: true,
//           derivationPath: "m/44'/1'/0'/0/"
//         }),
//       network_id: '3',
//     }
//   }
// };

  // Set default mocha options here, use special reporters etc.
  //mocha: {
    // timeout: 100000
  //},

  // Configure your compilers
  //compilers: {
  //  solc: {
    //  version: "0.8.11",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    //}
  //},

  // Truffle DB is currently disabled by default; to enable it, change enabled:
  // false to enabled: true. The default storage location can also be
  // overridden by specifying the adapter settings, as shown in the commented code below.
  //
  // NOTE: It is not possible to migrate your contracts to truffle DB and you should
  // make a backup of your artifacts to a safe location before enabling this feature.
  //
  // After you backed up your artifacts you can utilize db by running migrate as follows: 
  // $ truffle migrate --reset --compile-all
  //
  // db: {
    // enabled: false,
    // host: "127.0.0.1",
    // adapter: {
    //   name: "sqlite",
    //   settings: {
    //     directory: ".db"
    //   }
    // }
  // }
//};
