module base::esab {
    use std::option::{none, Option};
    use std::string::utf8;
    use aptos_std::bcs_stream::{BCSStream};
    use aptos_std::debug::print;

    public fun my_func(x: u64): u64 {
        print(&utf8(b"my_func @ esab"));
        x + 2
    }
}

