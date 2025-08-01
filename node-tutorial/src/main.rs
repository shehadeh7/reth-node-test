

#[global_allocator]
static ALLOC: reth_cli_util::allocator::Allocator = reth_cli_util::allocator::new_allocator();

use reth::{args::RessArgs, cli::Cli, ress::install_ress_subprotocol};
use reth_ethereum_cli::chainspec::EthereumChainSpecParser;
use reth_node_builder::NodeHandle;
use reth_node_ethereum::EthereumNode;

// use reth_node_ethereum::{EthereumAddOns, EthereumNode};
use tracing::info;


fn main() {
    reth_cli_util::sigsegv_handler::install();

    // Enable backtraces unless a RUST_BACKTRACE value has already been explicitly provided.
    if std::env::var_os("RUST_BACKTRACE").is_none() {
        unsafe { std::env::set_var("RUST_BACKTRACE", "1") };
    }

    if let Err(err) =
        Cli::parse_args().run(async move |builder, ress_args| {
            info!(target: "reth::cli", "Launching node");
            let NodeHandle { node, node_exit_future } =
                builder.node(EthereumNode::default()).launch_with_debug_capabilities().await?;



            node_exit_future.await
        })
    {
        eprintln!("Error: {err:?}");
        std::process::exit(1);
    }
}