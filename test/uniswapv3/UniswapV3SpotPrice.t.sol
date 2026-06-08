// BY GOD'S GRACE ALONE
/**
 * @notice A test script to compute the spot price of ...
 */

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console2} from "lib/forge-std/src/Test.sol";
import {IUniswapV3Pool} from "../../src/interfaces/uniswap-v3/IUniswapV3Pool.sol";
import {UNISWAP_V3_POOL_USDC_WETH_500} from "../../src/Constants.sol";
import {FullMath} from "../../src/uniswap-v3/FullMath.sol";

contract UniswapV3SwapTest is Test {
    // token0 X  (from X_Y POOL pool naming pattern)
    uint256 private constant USDC_DECIMALS = 1e6;
    // token1 Y
    uint256 private constant WETH_DECIMALS= 1e18;
    // 1 << 1 = 2 ** 1
    // 1 << 2 = 2 ** 2
    // 1 << 3 = 2 ** 3
    // .  .  .  .  .  .
    // .  .  .  .  .  .
    // .  .  .  .  .  .
    // .  .  .  .  .  .
    // 1 << 96 = 2 ** 96
    uint256 private constant Q96 = 1 << 96;
    // Address of the USDC-WETH pool contract (also known USDC-WETH liquidity pool) on mainnet
    IUniswapV3Pool private immutable pool = IUniswapV3Pool(UNISWAP_V3_POOL_USDC_WETH_500);

    // Get price of WETH in terms of USDC and return price with 18 decimals
    function test_spotPriceFromSqrtPriceX96() public {
        uint256 price = 0;
        IUniswapV3Pool.Slot0 memory slot0 = pool.slot0();

        // sqrtPriceX96 * sqrtPriceX96 might overflow
        // Hence the use of FullMath.mulDiv library utility to do uin256 * uint256 / uint256 without overflow
        // P = Y / X = WETH / USDC
        // ..........= price of USDC in terms of WETH
        // 1 / P = X / Y = USDC / WETH
        // ..............= price of WETH in terms of USDC

        // P has 1e18 / 1e6 = 1e12 decimals
        // 1 / P has 1e6 / 1e18 = 1e-12 decimals

        // sqrtPriceX96 = sqrt(P) * Q96
        // sqrtPriceX96 * sqrtPriceX96 might overflow
        // Thus use FullMath.mulDiv to do uint256 * uint256 / uint256 without overflow 
        price = FullMath.mulDiv(slot0.sqrtPriceX96, slot0.sqrtPriceX96, Q96);
        // price = sqrt(P) * Q96 * sqrt(P) * Q96 / Q96
        // ...... = P * Q96
        // 1 / price = 1 / (P * Q96)
        price = Q96 * 1e12 * 1e18 * 1 / price ; // The price returned is denominated in 1e-12, thus 1e12 is needed to cancel that out, 1e18 is included because the price to be returned is in 18 decimals

        assertGt(price, 0, "price = 0");
        console2.log("price %e", price);

        // Result: Logs:
        //   price 1.700391379691326632745e21 (~1700 USDC per WETH) and also in 18 decimals (on mainnet via a mainnet fork test) as of 11:56pm GMT+1 June 8, 2026 
    }

}
