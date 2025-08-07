# tryout-move-func
## Build and test
```
aptos move build --language-version 2.2

aptos move test --language-version 2.2
```

## Deploy
Note: available only on Testnet (Aug 8th 2025)

```
aptos init --profile hook_deployer --network=testnet

# base 
aptos move deploy-object --address-name base --package-dir hooks/base --profile hook_deployer --assume-yes --included-artifacts none --override-size-check

# router
aptos move deploy-object --address-name ppat --package-dir . --profile hook_deployer --named-addresses base=0x19f6feda4ac518a3d7a8a92ec4371ddf9f82be8756544c14e44a5d0027e459c3 --assume-yes --included-artifacts none --override-size-check --language-version 2.2
```