class Hardiot {
  late double lat;
  late double lng;
  late int checker;
  late double evc;
  late double lcid;
  late double engineRpm;
  late String fv;
  late double vehicleSpeed;
  late double engineLoad;
  late double coolantTemp;
  late double odometer;
  late double batLevel;
  late double exVoltage;
  late double fuelLevel;
  late double csq;
  Hardiot(
      {lat,
      lng,
      checker,
      evc,
      lcid,
      engineRpm,
      fv,
      vehicleSpeed,
      engineLoad,
      coolantTemp,
      odometer,
      batLevel,
      exVoltage,
      fuelLevel,
      csq}) {
    this.lat = lat;
    this.lng = lng;
    this.checker = checker;
    this.evc = evc;
    this.lcid = lcid;
    this.engineRpm = engineRpm;
    this.fv = fv;
    this.vehicleSpeed = vehicleSpeed;
    this.engineLoad = engineLoad;
    this.coolantTemp = coolantTemp;
    this.odometer = odometer;
    this.batLevel = batLevel;
    this.exVoltage = exVoltage;
    this.fuelLevel = fuelLevel;
    this.csq = csq;
  }
}
