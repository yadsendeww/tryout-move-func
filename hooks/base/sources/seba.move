module base::seba {
    use std::option::{none, Option};
    use std::string::utf8;
    use aptos_std::bcs_stream::{BCSStream};
    use aptos_std::debug::print;

    public fun my_func(x: u64): u64 {
        print(&utf8(b"my_func @ seba"));
        x + 3
    }

    public fun my_func_v2(x: u64, y: u64): u64 {
        print(&utf8(b"my_func_v2 @ seba"));
        x + y
    }
}

