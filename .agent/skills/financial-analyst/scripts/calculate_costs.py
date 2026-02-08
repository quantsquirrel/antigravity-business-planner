#!/usr/bin/env python3
"""
Business Financial Calculator

Usage:
    python calculate_costs.py --help
    python calculate_costs.py bep --fixed 5000000 --price 15000 --variable 8000
    python calculate_costs.py margin --cost 8000 --price 15000
    python calculate_costs.py monthly --revenue 30000000 --fixed 15000000 --variable-rate 0.45
"""

import argparse
import json
import sys


def calculate_bep(fixed_costs: float, price: float, variable_cost: float) -> dict:
    """Calculate Break-Even Point"""
    contribution_margin = price - variable_cost
    if contribution_margin <= 0:
        return {"error": "Variable cost exceeds or equals price"}
    bep_units = fixed_costs / contribution_margin
    bep_revenue = bep_units * price
    return {
        "fixed_costs": fixed_costs,
        "price_per_unit": price,
        "variable_cost_per_unit": variable_cost,
        "contribution_margin": contribution_margin,
        "bep_units": round(bep_units, 1),
        "bep_revenue": round(bep_revenue, 0),
        "margin_ratio": round(contribution_margin / price * 100, 1),
    }


def calculate_margin(cost: float, price: float) -> dict:
    """Calculate profit margins"""
    gross_profit = price - cost
    margin_pct = (gross_profit / price) * 100
    markup_pct = (gross_profit / cost) * 100
    return {
        "cost": cost,
        "price": price,
        "gross_profit": gross_profit,
        "margin_percent": round(margin_pct, 1),
        "markup_percent": round(markup_pct, 1),
        "cost_ratio": round((cost / price) * 100, 1),
    }


def calculate_monthly_pl(revenue: float, fixed: float, variable_rate: float) -> dict:
    """Calculate monthly P&L"""
    variable = revenue * variable_rate
    gross_profit = revenue - variable
    operating_profit = gross_profit - fixed
    return {
        "revenue": revenue,
        "variable_costs": round(variable, 0),
        "gross_profit": round(gross_profit, 0),
        "gross_margin": round((gross_profit / revenue) * 100, 1) if revenue > 0 else 0,
        "fixed_costs": fixed,
        "operating_profit": round(operating_profit, 0),
        "operating_margin": round((operating_profit / revenue) * 100, 1) if revenue > 0 else 0,
        "status": "profit" if operating_profit > 0 else "loss",
    }


def main():
    parser = argparse.ArgumentParser(description="Business Financial Calculator")
    subparsers = parser.add_subparsers(dest="command", help="Available calculations")

    bep_parser = subparsers.add_parser("bep", help="Break-Even Point calculation")
    bep_parser.add_argument("--fixed", type=float, required=True, help="Monthly fixed costs (KRW)")
    bep_parser.add_argument("--price", type=float, required=True, help="Price per unit (KRW)")
    bep_parser.add_argument("--variable", type=float, required=True, help="Variable cost per unit (KRW)")

    margin_parser = subparsers.add_parser("margin", help="Profit margin calculation")
    margin_parser.add_argument("--cost", type=float, required=True, help="Cost per unit (KRW)")
    margin_parser.add_argument("--price", type=float, required=True, help="Selling price (KRW)")

    monthly_parser = subparsers.add_parser("monthly", help="Monthly P&L calculation")
    monthly_parser.add_argument("--revenue", type=float, required=True, help="Monthly revenue (KRW)")
    monthly_parser.add_argument("--fixed", type=float, required=True, help="Monthly fixed costs (KRW)")
    monthly_parser.add_argument("--variable-rate", type=float, required=True, help="Variable cost ratio (0-1)")

    args = parser.parse_args()

    if args.command == "bep":
        result = calculate_bep(args.fixed, args.price, args.variable)
    elif args.command == "margin":
        result = calculate_margin(args.cost, args.price)
    elif args.command == "monthly":
        result = calculate_monthly_pl(args.revenue, args.fixed, args.variable_rate)
    else:
        parser.print_help()
        sys.exit(0)

    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
