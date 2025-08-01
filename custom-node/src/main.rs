#[global_allocator]
static ALLOC: reth_cli_util::allocator::Allocator = reth_cli_util::allocator::new_allocator();

use reth::{args::RessArgs, cli::Cli, ress::install_ress_subprotocol};
use reth_ethereum_cli::chainspec::EthereumChainSpecParser;
use reth_node_builder::NodeHandle;
use reth_node_ethereum::EthereumNode;
use reth_ethereum::{
    pool::TransactionPool
};
use futures_util::StreamExt;
use alloy_eips::BlockNumberOrTag;
use alloy_primitives::Address;
use alloy_rpc_types_eth::{state::EvmOverrides, TransactionRequest};


// use reth_node_ethereum::{EthereumAddOns, EthereumNode};
use tracing::info;

fn main() {
    reth_cli_util::sigsegv_handler::install();

    if std::env::var_os("RUST_BACKTRACE").is_none() {
        unsafe { std::env::set_var("RUST_BACKTRACE", "1") };
    }

    if let Err(err) = Cli::parse_args().run(async move |builder, _ress_args| {
        info!(target: "reth::cli", "Launching node");

        let NodeHandle { node, node_exit_future } =
            builder.node(EthereumNode::default()).launch_with_debug_capabilities().await?;

        // Clone the transaction pool so we can listen to incoming transactions
        let mut pending_transactions = node.pool.new_pending_pool_transactions_listener();
        let eth_api = node.rpc_registry.eth_api().clone();

        println!("Spawning trace task!");

        node.task_executor.spawn(Box::pin(async move {
            // Waiting for new transactions
            while let Some(event) = pending_transactions.next().await {
                let tx = event.transaction;
                println!("Transaction received: {tx:?}");
        }}));

        node_exit_future.await
    }) {
        eprintln!("Error: {err:?}");
        std::process::exit(1);
    }
}
