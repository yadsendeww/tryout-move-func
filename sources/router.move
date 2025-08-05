module tapp::router {
    use std::option::{Option, none};
    use std::signer::address_of;
    use aptos_std::bcs_stream;
    use aptos_std::bcs_stream::{BCSStream, deserialize_u64, deserialize_address};
    use aptos_std::debug::print;
    use aptos_std::ordered_map;
    use aptos_std::ordered_map::OrderedMap;
    use aptos_framework::object::{create_object, generate_signer, ExtendRef, generate_extend_ref, };

    struct MyFuncPredicate(|u64| u64) has copy, store;

    struct MyFuncStorage has key {
        myfunc: MyFuncPredicate,
        fallback_func: MyFuncPredicate,
    }

    public fun register_myfunc(
        signer: &signer,
        f: |u64| u64
    ) {
        let my_func: |u64| u64 has copy + drop + store =
            |x: u64| f(x);
        let fallback_fn: |u64| u64 has copy + drop + store =
            |x: u64| base::base::my_func(x);
        move_to(signer, MyFuncStorage {
            myfunc: MyFuncPredicate(my_func),
            fallback_func: MyFuncPredicate(fallback_fn),
        });
    }

    public fun exec_fn(signer: &signer, func_id: u64, arg: u64) acquires MyFuncStorage {
        let my_func_storage = &MyFuncStorage[address_of(signer)];
        let my_funcc = my_func_storage.myfunc;
        let fallback_func = my_func_storage.fallback_func;

        if (func_id > 0) {
            print(&my_funcc(arg));
        } else {
            print(&fallback_func(arg));
        }
    }

}
