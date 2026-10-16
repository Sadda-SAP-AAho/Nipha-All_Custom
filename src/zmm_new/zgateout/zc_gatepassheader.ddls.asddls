@Metadata.allowExtensions: true
@EndUserText.label: 'Gate Pass Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_GATEPASSHEADER
  provider contract transactional_query
  as projection on ZR_GATEPASSHEADER
{
  key GatePass,
      Plant,
      EntryDate,
      EntryTime,
      Type,
      SalesmanName,
      VehicleNumber,
      DriverName,
      DriverCode,
      RouteName,
      DriverNumber,
      TransporterName,
      Remarks,
      VehOutRemarks,
      Cmcrate1,
      Cmcrate2,
      Cmcrate3,
      Cmcrate4,
      Cb,
      MultiGPass,
      FirstGpNumber,
      FirstGpAmount,
      BillAmount,
      OutDate,
      OutTime,
      OutMeterReading,
      VehicleOut,
      Cancelled,
      VrnNo,
      WeighSlipNo,
      Duration_days,
      Duration_time,
      Grossweight,
      Tareweight,
      Netweight,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _GatePassLine : redirected to composition child ZC_GATEPASSLINEITM

}
