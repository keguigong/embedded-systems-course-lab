class Beacon
{
  int id;      //beacon's unique ID
  int rssi;    //RSSI value from the beacon
  Beacon (int i, int r)
  {
    id = i;
    rssi = r;
  }
}

  
float rssiToPower(int rssi)
{
  return pow(10, -3) * pow(10, rssi / 10);
}

float rssiToDistance(int rssi)
{
  int rssi_at_1m = -57; // Use getRssiAt1m() first to get rssi_at_1m                  
  //Modify your code here
  float P_r0 = rssiToPower(rssi_at_1m);
  float P_r = rssiToPower(rssi);
  return sqrt(P_r0 / P_r);
}

// For get rssi_at_1m, check the println value
void getRssiAt1m(Beacon[] received_beacon, int received_beacon_num)
{
  int ref_beacon_id = 100;
  if (received_beacon_num > 0)
  {
      for (int i = 0; i < received_beacon.length; i++)
      {
        if (received_beacon[i].id == ref_beacon_id)
        {
          println("Beacon ID: ", received_beacon[i].id, "RSSI: ", received_beacon[i].rssi);
          return;
        }
      }
  }
  println("No beacon received");
}

void calcPosition(Beacon[] received_beacon, int received_beacon_num)
{
  if (received_beacon_num > 0)    //check if there are beacon signals received
  {
    int max_rssi = -128;          //-128 dBm is the minimun value of RSSI
    int best_beacon_id = -1;
    Position locator_position = new Position(0, 0);
    float range = 0.0;

    //find the best beacon with best signal strength
    for (int i = 0; i < received_beacon.length; i++)
    {
      if (max_rssi < received_beacon[i].rssi)
      {
        max_rssi = received_beacon[i].rssi;
        best_beacon_id = received_beacon[i].id;
      }
    }

    //if a best signl signal beacon is found, update the locator's position
    if (best_beacon_id != -1)
    {
      locator_position = get_beacon_position(best_beacon_id);  //find the beacon's location based on its ID
      range = rssiToDistance(max_rssi);                        //calculate the range based on the rssi value using free-space path loss model
    }

    updateLocator(locator_position.x, locator_position.y, range);    //outputs the position of the locator on the map
  }
}
