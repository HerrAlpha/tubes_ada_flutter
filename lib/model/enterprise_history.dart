class EnterpriseHistory {
  int id;
  String name;
  int qty;
  String productPict;
  String createdAt;
  int productionPrice;
  String invoiceNumber;
  int status;
  int profit;
  int total;

  EnterpriseHistory(
      {
        required  this.id,
        required this.name,
        required this.qty,
        required this.productPict,
        required this.createdAt,
        required this.productionPrice,
        required this.profit,
        required this.total,
        required this.invoiceNumber,
        required this.status
      });
}
