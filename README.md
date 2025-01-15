<div align="center">
    <img src="https://github.com/1inch/farming/blob/master/.github/1inch_github_w.svg#gh-light-mode-only">
    <img src="https://github.com/1inch/farming/blob/master/.github/1inch_github_b.svg#gh-dark-mode-only">
</div>

# Spot Price Aggregator

[![Build Status](https://github.com/1inch/spot-price-aggregator/actions/workflows/test.yml/badge.svg)](https://github.com/1inch/spot-price-aggregator/actions)
[![Coverage Status](https://codecov.io/gh/1inch/spot-price-aggregator/branch/master/graph/badge.svg?token=6V7609YJ1Q)](https://codecov.io/gh/1inch/spot-price-aggregator)

The 1inch spot price aggregator is a set of smart contracts that extract price data for tokens traded on DEXes from the blockchain. To avoid price manipulations within a transaction, the spot price aggregator should ONLY be used off-chain. DO NOT use it on-chain. For off-chain usage see [Examples](#examples) section below.

## Wrappers

To handle wrapped tokens, such as wETH, cDAI, aDAI etc., the 1inch spot price aggregator uses custom wrapper smart contracts that wrap/unwrap tokens at the current wrapping exchange rate. 

## Connectors

If no direct liquidity pair exists between two tokens, the spot price aggregator calculates rates for those coins using another token that has pairs with both of them – a connector token.

## Supported Deployments

### Optimism (Optimistic)

#### Oracle [0x59114D308C6DE4A84F5F8cD80485a5481047b99f](https://optimistic.etherscan.io/address/0x59114D308C6DE4A84F5F8cD80485a5481047b99f)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0xF82D282E9FAcE46F73835e775330fD4770654f1A](https://optimistic.etherscan.io/address/0xF82D282E9FAcE46F73835e775330fD4770654f1A)
   * Slipstream - [0x799bF23950F2B2e28b8a2A0ea78fd8Ca4f61fD9c](https://optimistic.etherscan.io/address/0x799bF23950F2B2e28b8a2A0ea78fd8Ca4f61fD9c)

</details>

<details><summary>Supported wrappers</summary>

   * AaveV3 - [0x0c8fc7a71C28c768FDC1f7d75835229beBEB1573](https://optimistic.etherscan.io/address/0x0c8fc7a71C28c768FDC1f7d75835229beBEB1573)
   * StataTokens (AaveV3) - [0x1A75DF59f464a70Cc8f7383983852FF72e5F5167](https://optimistic.etherscan.io/address/0x1A75DF59f464a70Cc8f7383983852FF72e5F5167)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://optimistic.etherscan.io/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * WETH - [0x4200000000000000000000000000000000000006](https://optimistic.etherscan.io/address/0x4200000000000000000000000000000000000006)
   * USDC.e - [0x7F5c764cBc14f9669B88837ca1490cCa17c31607](https://optimistic.etherscan.io/address/0x7F5c764cBc14f9669B88837ca1490cCa17c31607)
   * USDC - [0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85](https://optimistic.etherscan.io/address/0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85)
   * USDT - [0x94b008aA00579c1307B0EF2c499aD98a8ce58e58](https://optimistic.etherscan.io/address/0x94b008aA00579c1307B0EF2c499aD98a8ce58e58)
   * DAI - [0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1](https://optimistic.etherscan.io/address/0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1)
   * WSETH - [0x68f180fcCe6836688e9084f035309E29Bf0A2095](https://optimistic.etherscan.io/address/0x1F32b1c2345538c0c6f582fCB022739c4A194Ebb)
   * OP - [0x4200000000000000000000000000000000000042](https://optimistic.etherscan.io/address/0x4200000000000000000000000000000000000042)
   * SUSD - [0x4200000000000000000000000000000000000042](https://optimistic.etherscan.io/address/0x8c6f28f2F1A3C87F0f938b96d27520d9751ec8d9)

</details>

### Base

#### Oracle [0x3B06c787711ecb5624cE65AC8F26cde10831eb0C](https://basescan.org/address/0x3B06c787711ecb5624cE65AC8F26cde10831eb0C)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0x309E98D9A45d7294f0F85f8d986BB0C6EB01cc39](https://basescan.org/address/0x309E98D9A45d7294f0F85f8d986BB0C6EB01cc39)
   * Slipstream - [0x42430f1D93acbd5F38128fe4DBdde3c5B09a2b7E](https://basescan.org/address/0x42430f1D93acbd5F38128fe4DBdde3c5B09a2b7E)

</details>

<details><summary>Supported wrappers</summary>

   * WETH - [0x3Ce81621e674Db129033548CbB9FF31AEDCc1BF6](https://basescan.org/address/0x3Ce81621e674Db129033548CbB9FF31AEDCc1BF6)
   * AaveV3 - [0x0c8fc7a71C28c768FDC1f7d75835229beBEB1573](https://basescan.org/address/0x0c8fc7a71C28c768FDC1f7d75835229beBEB1573)
   * StataTokens (AaveV3) - [0x1A75DF59f464a70Cc8f7383983852FF72e5F5167](https://basescan.org/address/0x1A75DF59f464a70Cc8f7383983852FF72e5F5167)
   * CompoundV3 - [0x3afA12cf9Ac1a96845973BD93dBEa183A94DD74F](https://basescan.org/address/0x3afA12cf9Ac1a96845973BD93dBEa183A94DD74F)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://basescan.org/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * WETH - [0x4200000000000000000000000000000000000006](https://basescan.org/address/0x4200000000000000000000000000000000000006)
   * USDC - [0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913](https://basescan.org/address/0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913)
   * DAI - [0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb](https://basescan.org/address/0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb)

</details>

### Mode

#### Oracle [0xbAEe949B52cb503e39f1Df54Dcee778da59E11bc](https://explorer.mode.network/address/0xbAEe949B52cb503e39f1Df54Dcee778da59E11bc)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0xF6cE387e11Cb8195C192c5E09b0E937D2B43665e](https://explorer.mode.network/address/0xF6cE387e11Cb8195C192c5E09b0E937D2B43665e)
   * Slipstream - [0xE7520590779811C2fE97419D15864E5000d54a5b](https://explorer.mode.network/address/0xE7520590779811C2fE97419D15864E5000d54a5b)

</details>

<details><summary>Supported wrappers</summary>

   * Ionic - [0x6C1f5De46D459aa44AfC0B42008825dA6b9d3635](https://explorer.mode.network/address/0x6C1f5De46D459aa44AfC0B42008825dA6b9d3635)
   * LayerBank - [0x8Ea46a9396A1594eC9136Bd922555C0dbcA21655](https://explorer.mode.network/address/0x8Ea46a9396A1594eC9136Bd922555C0dbcA21655)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://explorer.mode.network/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * WETH - [0x4200000000000000000000000000000000000006](https://explorer.mode.network/address/0x4200000000000000000000000000000000000006)
   * MODE - [0xDfc7C877a950e49D2610114102175A06C2e3167a](https://explorer.mode.network/address/0xDfc7C877a950e49D2610114102175A06C2e3167a)
   * USDC - [0xd988097fb8612cc24eeC14542bC03424c656005f](https://explorer.mode.network/address/0xd988097fb8612cc24eeC14542bC03424c656005f)
   * USDT - [0xf0F161fDA2712DB8b566946122a5af183995e2eD](https://explorer.mode.network/address/0xf0F161fDA2712DB8b566946122a5af183995e2eD)

</details>

### Bob

#### Oracle [0x611917785D8d1221E8Eca045580e3A14C4254Ab5](https://explorer.gobob.xyz/address/0x611917785D8d1221E8Eca045580e3A14C4254Ab5)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0xabE4cbcE47707D7A74bF6F1a343FF2c92267D3ea](https://explorer.gobob.xyz/address/0xabE4cbcE47707D7A74bF6F1a343FF2c92267D3ea)

</details>

<details><summary>Supported wrappers</summary>

   * ShoeBill - [0x1420e7e37d1915E075299DFCe60Ee0c6b682793E](https://explorer.gobob.xyz/address/0x1420e7e37d1915E075299DFCe60Ee0c6b682793E)
   * LayerBank - [0x2169b9f7feC5e283DCAe43e364E0AAD26CB13bcB](https://explorer.gobob.xyz/address/0x2169b9f7feC5e283DCAe43e364E0AAD26CB13bcB)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://explorer.gobob.xyz/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * WETH - [0x4200000000000000000000000000000000000006](https://explorer.gobob.xyz/address/0x4200000000000000000000000000000000000006)
   * USDC.e - [0xe75D0fB2C24A55cA1e3F96781a2bCC7bdba058F0](https://explorer.gobob.xyz/address/0xe75D0fB2C24A55cA1e3F96781a2bCC7bdba058F0)
   * USDT - [0x05D032ac25d322df992303dCa074EE7392C117b9](https://explorer.gobob.xyz/address/0x05D032ac25d322df992303dCa074EE7392C117b9)
   * WBTC - [0x03C7054BCB39f7b2e5B2c7AcB37583e32D70Cfa3](https://explorer.gobob.xyz/address/0x03C7054BCB39f7b2e5B2c7AcB37583e32D70Cfa3)

</details>

### Lisk

#### Oracle [0x024503003fFE9AF285f47c1DaAaA497D9f1166D0](https://blockscout.lisk.com/address/0x024503003fFE9AF285f47c1DaAaA497D9f1166D0)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0xA83Efe588141B580F5E7c666cB6dcb321A217428](https://blockscout.lisk.com/address/0xA83Efe588141B580F5E7c666cB6dcb321A217428)
   * Slipstream - [0xC60A684E00f2aEc11603348A615cb2b454B62e31](https://blockscout.lisk.com/address/0xC60A684E00f2aEc11603348A615cb2b454B62e31)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://blockscout.lisk.com/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * USDT - [0x05D032ac25d322df992303dCa074EE7392C117b9](https://blockscout.lisk.com/address/0x05D032ac25d322df992303dCa074EE7392C117b9)
   * USDC.e - [0xF242275d3a6527d877f2c927a82D9b057609cc71](https://blockscout.lisk.com/address/0xF242275d3a6527d877f2c927a82D9b057609cc71)
   * WETH - [0x4200000000000000000000000000000000000006](https://blockscout.lisk.com/address/0x4200000000000000000000000000000000000006)
   * LSK - [0xac485391EB2d7D88253a7F1eF18C37f4242D1A24](https://blockscout.lisk.com/address/0xac485391EB2d7D88253a7F1eF18C37f4242D1A24)
   * XVELO - [0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81](https://blockscout.lisk.com/address/0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81)

</details>

### Fraxtal

#### Oracle [0x4817f8D70aE32Ee96e5E6BFA24eb7Fcfa83bbf29](https://fraxscan.com/address/0x4817f8D70aE32Ee96e5E6BFA24eb7Fcfa83bbf29)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0xE6423B79A3a95dD76DFc2D5183a6329837bbD051](https://fraxscan.com/address/0xE6423B79A3a95dD76DFc2D5183a6329837bbD051)
   * Slipstream - [0xfc8589901150cb1600381F36E936b817B6251919](https://fraxscan.com/address/0xfc8589901150cb1600381F36E936b817B6251919)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://fraxscan.com/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * FRAX - [0xFc00000000000000000000000000000000000001](https://fraxscan.com/address/0xFc00000000000000000000000000000000000001)
   * wfrxETH - [0xFC00000000000000000000000000000000000006](https://fraxscan.com/address/0xFC00000000000000000000000000000000000006)
   * sfrxETH - [0xFC00000000000000000000000000000000000005](https://fraxscan.com/address/0xFC00000000000000000000000000000000000005)
   * USDe - [0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34](https://fraxscan.com/address/0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34)
   * sUSDe - [0x211Cc4DD073734dA055fbF44a2b4667d5E5fE5d2](https://fraxscan.com/address/0x211Cc4DD073734dA055fbF44a2b4667d5E5fE5d2)
   * USDC - [0xDcc0F2D8F90FDe85b10aC1c8Ab57dc0AE946A543](https://fraxscan.com/address/0xDcc0F2D8F90FDe85b10aC1c8Ab57dc0AE946A543)
   * WETH - [0x4200000000000000000000000000000000000006](https://fraxscan.com/address/0x4200000000000000000000000000000000000006)

</details>

### Metal

#### Oracle [0x3e71CCdf495d9628D3655A600Bcad3afF2ddea98](https://explorer.metall2.com/address/0x3e71CCdf495d9628D3655A600Bcad3afF2ddea98)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0x593D092BB28CCEfe33bFdD3d9457e77Bd3084271](https://explorer.metall2.com/address/0x593D092BB28CCEfe33bFdD3d9457e77Bd3084271)
   * Slipstream - [0x8Eb6838B4e998DA08aab851F3d42076f21530389](https://explorer.metall2.com/address/0x8Eb6838B4e998DA08aab851F3d42076f21530389)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://explorer.metall2.com/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * USDC - [0xb91CFCcA485C6E40E3bC622f9BFA02a8ACdEeBab](https://explorer.metall2.com/address/0xb91CFCcA485C6E40E3bC622f9BFA02a8ACdEeBab)
   * WETH - [0x4200000000000000000000000000000000000006](https://explorer.metall2.com/address/0x4200000000000000000000000000000000000006)
   * MTL - [0xBCFc435d8F276585f6431Fc1b9EE9A850B5C00A9](https://explorer.metall2.com/address/0xBCFc435d8F276585f6431Fc1b9EE9A850B5C00A9)
   * XVELO - [0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81](https://explorer.metall2.com/address/0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81)

</details>

### Soneium

#### Oracle [0xe58920a8c684CD3d6dCaC2a41b12998e4CB17EfE](https://soneium.blockscout.com/address/0xe58920a8c684CD3d6dCaC2a41b12998e4CB17EfE)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0x34a26CA2dFb98f4440e6B5bbFAA854dd72B1E39b](https://soneium.blockscout.com/address/0x34a26CA2dFb98f4440e6B5bbFAA854dd72B1E39b)
   * Slipstream - [0x0D6d3Da47E495c0249073B6587E44Da1d2f35070](https://soneium.blockscout.com/address/0x0D6d3Da47E495c0249073B6587E44Da1d2f35070)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://soneium.blockscout.com/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * USDC - [0xbA9986D2381edf1DA03B0B9c1f8b00dc4AacC369](https://soneium.blockscout.com/address/0xbA9986D2381edf1DA03B0B9c1f8b00dc4AacC369)
   * WETH - [0x4200000000000000000000000000000000000006](https://soneium.blockscout.com/address/0x4200000000000000000000000000000000000006)
   * XVELO - [0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81](https://soneium.blockscout.com/address/0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81)

</details>

### Ink

#### Oracle [0xe58920a8c684CD3d6dCaC2a41b12998e4CB17EfE](https://explorer.inkonchain.com/address/0xe58920a8c684CD3d6dCaC2a41b12998e4CB17EfE)

<details><summary>Supported DEXes</summary>

   * VelodromeV2 - [0x34a26CA2dFb98f4440e6B5bbFAA854dd72B1E39b](https://explorer.inkonchain.com/address/0x34a26CA2dFb98f4440e6B5bbFAA854dd72B1E39b)
   * Slipstream - [0x0D6d3Da47E495c0249073B6587E44Da1d2f35070](https://explorer.inkonchain.com/address/0x0D6d3Da47E495c0249073B6587E44Da1d2f35070)

</details>

<details><summary>Supported connectors</summary>

   * NONE - [0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF](https://explorer.inkonchain.com/address/0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
   * USDC - [0xF1815bd50389c46847f0Bda824eC8da914045D14](https://explorer.inkonchain.com/address/0xb91CFCcA485C6E40E3bC622f9BFA02a8ACdEeBab)
   * WETH - [0x4200000000000000000000000000000000000006](https://explorer.inkonchain.com/address/0x4200000000000000000000000000000000000006)
   * XVELO - [0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81](https://explorer.inkonchain.com/address/0x7f9AdFbd38b669F03d1d11000Bc76b9AaEA28A81)

</details>

## Examples

* [Single token-to-ETH price usage](https://github.com/1inch-exchange/offchain-oracle/blob/master/examples/single-price.js)

* [Multiple token-to-ETH prices usage](https://github.com/1inch-exchange/offchain-oracle/blob/master/examples/multiple-prices.js)
