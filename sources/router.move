module ppat::router {
    use aptos_std::bcs_stream;
    use aptos_std::bcs_stream::{deserialize_u64};
    use aptos_std::debug::print;
    use aptos_std::ordered_map;
    use aptos_std::ordered_map::OrderedMap;

    #[test_only]
    use aptos_framework::account::create_signer_for_test;

    struct HookRegistry has key {
        hooks_count: u64,
        hooks: OrderedMap<u64, address>
    }

    struct MyFuncPredicate(|u64| u64) has copy, drop, store;

    struct MyFuncV2Predicate(|u64, u64| u64) has copy, drop, store;

    struct FuncStorage<T: copy + drop + store> has key, store {
        f: T
    }

    fun init_module(signer: &signer) {
        move_to(
            signer,
            HookRegistry { hooks_count: 0, hooks: ordered_map::new() }
        );
    }

    /// hook register its predicate
    public fun register_predicate(
        signer: &signer, fn: |u64| u64 has copy + drop + store
    ) {
        move_to(signer, FuncStorage { f: MyFuncPredicate(fn) });
    }

    /// hook register its predicate
    public fun register_v2_predicate(
        signer: &signer, fn: |u64, u64| u64 has copy + drop + store
    ) {
        move_to(signer, FuncStorage { f: MyFuncV2Predicate(fn) });
    }

    /// admin approve hook
    public fun register_hook(hook_addr: address) acquires HookRegistry {
        let reg = &mut HookRegistry[@ppat];
        let hook_type = reg.hooks_count;
        reg.hooks.add(hook_type, hook_addr);
        reg.hooks_count += 1;
    }

    /// hook call via router
    public entry fun exec_my_func(
        _signer: &signer, hook_type: u64, args: vector<u8>
    ) acquires FuncStorage, HookRegistry {
        let reg = &HookRegistry[@ppat];
        let hook_addr = *reg.hooks.borrow(&hook_type);

        let stream = &mut bcs_stream::new(args);

        // hooks could have different function signatures
        // backward compatible betweens: ... > v2 > v1
        if (exists<FuncStorage<MyFuncV2Predicate>>(hook_addr)) {
            let arg0 = deserialize_u64(stream);
            let arg1 = deserialize_u64(stream);
            let my_func_predicate = &FuncStorage<MyFuncV2Predicate>[hook_addr];
            let my_func = my_func_predicate.f;
            print(&my_func(arg0, arg1));
            return
        } else if (exists<FuncStorage<MyFuncPredicate>>(hook_addr)) {
            let arg = deserialize_u64(stream);
            let my_func_predicate = &FuncStorage<MyFuncPredicate>[hook_addr];
            let my_func = my_func_predicate.f;
            print(&my_func(arg));
            return
        }
    }

    #[test_only]
    public fun init_module_for_testing() {
        init_module(&create_signer_for_test(@ppat));
    }
}

