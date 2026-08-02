# BR #18 - Market Basket Analysis

## Business Requirement

The Sales & Marketing Manager wants to discover products that are frequently purchased together in the same order.
This information will help improve:
- Cross Selling
- Product Bundeling
- Store Layout
- Promotional campaigns 
- Recommendation Systems ("Customer who bought X also bought Y")

## Business Objectives

- Which products are most frequently purchased together?
- How many orders contain each product pair?
- Which product combinations are most popular?
- Which products should be bundeled together?
- Which products should be placed near each other in stores?
  
## Grain of Report

**One row reperesent one unique pair of products purchased together in completed sales during calendar year 2025.**

## Skills to gain

- Self join a fact table
- Generate unique product pairs
- Count orders containing each pair
- Rank product combinations
- Build a market basket report
- Answer cross-selling questions

## KPIs

- Order Together
- Pair Rank
- Product A
- Product B
- Pair Contribution %
- Support
- Confidence
- Lift

## Tables Required

Fact Sales
- DateKey
- ProductKey
- OrderNumber
- SalesStatus

DimDate
- DateKey
- CalendarYear

DimProduct
- ProductKey
- ProductId
- ProductName
- Category

## Query Design

CTE 1- OrderProduct
- OrderNumber
- ProductKey

CTE 2- ProductPair
- Self Join to create Product Pairs
- ProductKey1 < ProductKey2 (Prevent duplicate Pairs)

CTE 3- PairFrequency
- Group By ProductPair 
- Calculate OrderTogether
  
CTE 4- ProductRanking
- Pair Rank
- Rank()OVER (ORDER BY OrderTogether DESC)

FINAL SELECT
- Join DimProduct Twice
- ProductKey 1 -> Product A
- ProductKey 2 -> Product B

## OUTPUT

Product A | Product B | OrderTogether | PairRank

