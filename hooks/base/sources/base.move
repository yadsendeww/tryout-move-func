module base::base {
    use std::option::{none, Option};
    use aptos_std::bcs_stream::{BCSStream};

    #[event]
    struct Created has drop, store {}

    #[event]
    struct Deposited has drop, store {}

    #[event]
    struct Withdrawn has drop, store {}

    public fun my_func(x: u64): u64 {
        x + 1
    }

    public fun get_func(): |u64| u64 {
        let f: |u64| u64 has copy+drop+store = |x: u64| my_func(x);
        f
    }

    public fun create_vault(
        _pool_signer: &signer,
        _assets: vector<address>,
        _stream: &mut BCSStream,
        _creator: address
    ) {}

    public fun deposit(
        _pool_signer: &signer,
        _position_idx: Option<u64>,
        stream: &mut BCSStream,
        _creator: address
    ): (vector<u64>, Option<u64>) {
        (vector[], none())
    }

    public fun withdraw(
        pool_signer: &signer,
        _position_idx: u64,
        stream: &mut BCSStream,
        _creator: address
    ): (vector<u64>, Option<u64>) {
        (vector[], none())
    }
}
