describe "Quickeebooks::Online::Model::SalesReceipt" do
# <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
# <SalesReceipt xmlns="http://www.intuit.com/sb/cdm/v2" xmlns:ns2="http://www.intuit.com/sb/cdm/qbopayroll/v1" xmlns:ns3="http://www.intuit.com/sb/cdm/qbo">
# <Id idDomain="QBO">8</Id>
# <SyncToken>0</SyncToken>
# <MetaData>
# <CreateTime>2010-10-21T23:05:21-07:00</CreateTime>
# <LastUpdatedTime>2010-10-21T23:05:21-07:00</LastUpdatedTime>
# </MetaData>
# <Header>
# <DocNumber>1006</DocNumber>
# <TxnDate>2010-10-22-07:00</TxnDate>
# <CustomerId>4</CustomerId>
# <SalesTaxCodeId idDomain="QBO">1</SalesTaxCodeId>
# <SalesTaxCodeName>IS_TAXABLE</SalesTaxCodeName>
# <SubTotalAmt>2500.00</SubTotalAmt>
# <TotalAmt>2500.00</TotalAmt>
# <ToBePrinted>false</ToBePrinted>
# <ToBeEmailed>false</ToBeEmailed>
# <ShipAddr>
# <Line1>Mountain View</Line1>
# <CountrySubDivisionCode>US</CountrySubDivisionCode>
# </ShipAddr>
# <DepositToAccountId>4</DepositToAccountId>
# <DepositToAccountName>Undeposited Funds</DepositToAccountName>
# <DiscountTaxable>true</DiscountTaxable>
# </Header>
# <Line>
# <Id>1</Id>
# <Desc>Keyboards</Desc>
# <Amount>2500.00</Amount>
# <Taxable>false</Taxable>
# <ItemId>1</ItemId>
# <UnitPrice>10</UnitPrice>
# <Qty>2</Qty>
# </Line>
# </SalesReceipt>
  describe "parse invoice from XML" do
    xml = onlineFixture("sales_receipt.xml")
    sales_receipt = Quickeebooks::Online::Model::SalesReceipt.from_xml(xml)
    puts sales_receipt.inspect
    sales_receipt.id.value.should == "8"
    sales_receipt.sync_token.should == 0
    sales_receipt.doc_number.should == 1006
    sales_receipt.header.customer_id.should == 4
    sales_receipt.subtotal.should == 2500.00
    sales_receipt.total.should == 2500.00

    line_item = sales_receipt.line_items.first
    line_item.desc.should == "Keyboards"
    line_item.amount.should == 2500.00
    line_item.taxable.should be_false
    line_item.unit_price.should == 10
    line_item.quantity.should == 2
  end
end
