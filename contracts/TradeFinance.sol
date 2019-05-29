pragma solidity 0.4.25;

contract TradeFinance{
    
    struct Buyer{
        uint buyerId;
        string buyerName;
        string country;
        address buyerAddress;
        uint buyerBalance;
    }
    
    struct Seller{
        uint sellerId;
        string sellerName;
        string country;
        address sellerAddress;
        uint sellerBalance;
    }
    
    struct FinancialInstitution{
        uint FIId;
        string FIName;
        address FIAddress;
        uint FIBalance;
    }
    
    struct Product{
        uint productId;
        string productName;
        uint quantity;
        uint productPrice;
    }
    
    struct ProductStatus{
        uint invoiceId;
        string productName;
        uint quantity;
        uint productPrice;
        bool IsitSeller;
        string status; // seller accept or not 
        uint advaceAmount;
        bool IsitFI;
        bool IsitApproved; // FI approved or not  
        bool advaceAmountReceived;
        bool ProductTransfered;
        uint Amount;
        uint RemainingBalance;
    }
    
    mapping(uint => Buyer) public buyers;
    mapping(uint => Seller) public sellers;
    mapping(uint => FinancialInstitution) public fis;
    mapping(uint => Product) public products;
    mapping(uint => ProductStatus) public productstatus;
    address buyer;
    address seller;
    address Financialinstitution;
    
    modifier onlyBuyer() {
        require(msg.sender == buyer);
        _;
    }
    
    modifier onlySeller() {
        require(msg.sender == seller);
        _;
    }
    
    modifier onlyFinancialInstitution() {
        require(msg.sender == Financialinstitution);
        _;
    }
    
    constructor(address _buyer, address _seller, address _Financialinstitution) public {
        require( _buyer != address(0));
        require( _seller != address(0));
        require( _Financialinstitution != address(0));
        buyer = _buyer;
        seller = _seller;
        Financialinstitution = _Financialinstitution;
    }
    
    function setBuyer(uint buyerId, string memory buyerName, string memory country, address buyerAddress, uint buyerBalance) onlyBuyer public {
        Buyer storage b = buyers[buyerId];
        b.buyerId = buyerId;
        b.buyerName = buyerName;
        b.country = country;
        b.buyerAddress = buyerAddress;
        b.buyerBalance = buyerBalance;
    }
    
    function setSeller(uint sellerId, string memory sellerName, string memory country, address sellerAddress, uint sellerBalance) onlySeller public {
        Seller storage s = sellers[sellerId];
        s.sellerId = sellerId;
        s.sellerName = sellerName;
        s.country = country;
        s.sellerAddress = sellerAddress;
        s.sellerBalance = sellerBalance;
    }
    
    function setFinancialInstitution(uint FIId, string memory FIName, address FIAddress, uint FIBalance) onlyFinancialInstitution public{
        FinancialInstitution storage f = fis[FIId];
        f.FIId = FIId;
        f.FIName = FIName;
        f.FIAddress = FIAddress;
        f.FIBalance = FIBalance;
    }
    
    //send request by buyer
    function sendRequestByBuyer(uint productId, string memory productName, uint quantity, uint productPrice) onlyBuyer public {
        Product storage p = products[productId];
        p.productId = productId;
        p.productName = productName;
        p.quantity = quantity;
        p.productPrice = productPrice;
    }
    
    // accepted request and share invoice by seller to buyer and FI
    function requestAcceptedBySeller(uint invoiceId, string memory productName, uint quantity, uint productPrice, uint advaceAmount) onlySeller public  {
        ProductStatus storage ps = productstatus[invoiceId];
        ps.invoiceId = invoiceId;
        ps.productName = productName;
        ps.quantity = quantity;
        ps.productPrice = productPrice;
        ps.advaceAmount = advaceAmount;
        ps.IsitSeller = true;
        ps.status = 'Accept';
        ps.IsitFI;
        ps.IsitApproved;
        
    }
    
    //FI accept request
    function requestAcceptedByFI(uint invoiceId) onlyFinancialInstitution public  {
        ProductStatus storage ps = productstatus[invoiceId];
        ps.invoiceId = invoiceId;
        ps.IsitSeller = true;
        ps.status = 'Accept';
        ps.IsitFI = true;
        ps.IsitApproved = true;
    }
    
    // fi send advaceAmount to seller
    function sendAdvanceAmountToSellerByFI(uint invoiceId, uint FIId, uint sellerId, uint advaceAmount) onlyFinancialInstitution payable public {
        Seller storage s = sellers[sellerId];
        FinancialInstitution storage f = fis[FIId];
        ProductStatus storage ps = productstatus[invoiceId];
        require(ps.IsitFI == true);
        require(ps.IsitApproved == true);
        ps.advaceAmount = advaceAmount;
        s.sellerBalance += msg.value;
        f.FIBalance -= msg.value;
    }
    
    // seller send product to buyer
    function productTransferedBySeller(uint invoiceId) onlySeller public {
        ProductStatus storage ps = productstatus[invoiceId];
        require(ps.advaceAmountReceived == true);
        ps.ProductTransfered = true;
    }
    
    // buyer send amount to fi
    function sendAmountToFIByBuyer(uint invoiceId, uint FIId, uint buyerId, uint Amount) onlyBuyer payable public {
        ProductStatus storage ps = productstatus[invoiceId];
        ps.Amount = Amount;
        require(ps.ProductTransfered == true);
        Buyer storage b = buyers[buyerId];
        FinancialInstitution storage f = fis[FIId];
        f.FIBalance += msg.value;
        b.buyerBalance -= msg.value;
    }
    
    // fi send amount to seller
    function sendRemainingAmountToSellerByFI(uint invoiceId, uint FIId, uint sellerId, uint RemainingBalance) onlyFinancialInstitution payable public {
        ProductStatus storage ps = productstatus[invoiceId];
        ps.RemainingBalance = RemainingBalance;
        require(ps.ProductTransfered == true);
        Seller storage s = sellers[sellerId];
        FinancialInstitution storage f = fis[FIId];
        s.sellerBalance += msg.value;
        f.FIBalance -= msg.value;
    }

}