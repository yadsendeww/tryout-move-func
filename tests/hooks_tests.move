#[test_only]
module ppat::hooks_tests {
    use std::bcs::to_bytes;
    use std::signer::address_of;
    use aptos_framework::account::create_signer_for_test;

    #[test(signer = @0x99)]
    fun register_vault_hook(signer: &signer) {
        let hook0_signer = &create_signer_for_test(@0xb0101);
        let hook1_signer = &create_signer_for_test(@0xb1111);
        let hook2_signer = &create_signer_for_test(@0xb2222);

        ppat::router::init_module_for_testing();

        ppat::router::register_predicate(hook0_signer, base::base::my_func);
        ppat::router::register_hook(address_of(hook0_signer));

        ppat::router::register_predicate(hook1_signer, base::esab::my_func);
        ppat::router::register_hook(address_of(hook1_signer));

        ppat::router::register_predicate(hook2_signer, base::seba::my_func);
        ppat::router::register_v2_predicate(hook2_signer, base::seba::my_func_v2);
        ppat::router::register_hook(address_of(hook2_signer));

        // test routing between different hooks
        let args = vector[];
        args.append(to_bytes(&99u64));
        ppat::router::exec_my_func(signer, 0, args);

        let args = vector[];
        args.append(to_bytes(&99u64));
        ppat::router::exec_my_func(signer, 1, args);

        let args = vector[];
        args.append(to_bytes(&99u64));
        args.append(to_bytes(&99u64));
        ppat::router::exec_my_func(signer, 2, args);
    }
}

