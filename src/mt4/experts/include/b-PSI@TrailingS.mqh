//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|                                                               b-PSI@Trailing.mqh  |
//|                                                                      TarasBY&I_D  |
//|                                   ������� �� "����" ������� �� I_D / ���� ������  |
//|                                                 http://codebase.mql4.com/ru/1101  |
//|  19.10.2011  ���������� ������� ��������� "� ����� �������".                      |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
#property copyright "Copyright � 2011, TarasBY WM Z670270286972"
#property link      "taras_bulba@tut.by"
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|                 *****        ��������� ����������         *****                   |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
extern string SETUP_Trailing        = "================== TRAILING ===================";
extern int    N_Trailing               = 0;          // ������� ������������� ���������
extern int    Trail_Period             = PERIOD_H1;  // ������ (�������), �� ������� ���������� �������
extern bool   TrailLOSS_ON             = FALSE;      // ��������� ��������� �� LOSS`e
extern int    TrailLossAfterBar        = 12;         // ����� ������ �� ����� ���� (����� ��������) �������� ������� �� �����
extern int    TrailStep                = 5;          // ��� ��������� (����������� ����������)
extern int    ProfitMIN                = 3;          // ����������� ������ � ��.
extern string Setup_TrailStairs     = "------------- N0 - TrailingStairs -------------";
extern int    TrailingStop            = 50;         // ���������� ����-������, ���� ����� ��������� ���
extern int    BreakEven                = 30;         // �������, �� ������� ����������� ��������� �� ������� � ProfitMIN
extern string Setup_TrailByFractals = "----------- N1 - TrailingByFractals -----------";
extern int    BarsInFractal            = 0;          // ���������� ����� � ��������
extern int    Indent_Fr                = 0;          // ������ (��.) - ���������� �� ����\��� �����, �� ������� ����������� SL (�� 0)
extern string Setup_TrailByShadows  = "----------- N2 - TrailingByShadows ------------";
extern int    BarsToShadows            = 0;          // ���������� �����, �� ����� ������� ���������� ������������� (�� 1 � ������)
extern int    Indent_Sh                = 0;          // ������ (��.) - ���������� �� ����\��� �����, �� ������� ����������� SL (�� 0)
extern string Setup_TrailUdavka     = "------------- N3 - TrailingUdavka -------------";
extern int    Level_1                  = 40;         // �� ���� ������ �������� ����������
extern int    Distance_1               = 70;         // �� ���� ���������� ������ ��������� = Level_1
extern int    Level_2                  = 30;         // ������ ��������� �\� Distance_1 �� Distance_2
extern int    Distance_2               = 100;        // �� Distance_1 �� Distance_2 ������ ��������� = Level_2
extern int    Level_3                  = 20;         // ����� ��������� Distance_2 ������ ��������� = Level_3
extern string Setup_TrailByTime     = "------------- N4 - TrailingByTime -------------";
extern int    Interval                 = 60;         // �������� (�����), � ������� ������������� SL
extern int    TimeStep                 = 5;          // ��� ��������� (�� ������� �������) ������������ SL
extern string Setup_TrailByATR      = "------------- N5 - TrailingByATR --------------";
extern int    ATR_Period1              = 9;          // ������ ������� ATR (������ 0; ����� ���� ����� ATR_Period2, �� ����� ������� �� ����������)
extern int    ATR_shift1               = 2;          // ��� ������� ATR ����� "����" (��������������� ����� �����)
extern int    ATR_Period2              = 14;         // ������ ������� ATR (������ 0)
extern int    ATR_shift2               = 3;          // ��� ������� ATR ����� "����", (��������������� ����� �����)
extern double ATR_coeff                = 2.5;        // 
extern string Setup_TrailRatchetB   = "------------ N6 - TrailingRatchetB ------------";
extern int    ProfitLevel_1            = 20;
extern int    ProfitLevel_2            = 30;
extern int    ProfitLevel_3            = 50;
extern int    StopLevel_1              = 2;
extern int    StopLevel_2              = 5;
extern int    StopLevel_3              = 15;
extern string Setup_TrailByPriceCh  = "--------- N7 - TrailingByPriceChannel ---------";
extern int    BarsInChannel            = 10;        // ������ (���-�� �����) ��� �������� ������� � ������ ������ ������
extern int    Indent_Pr                = 15;        // ������ (�������), �� ������� ����������� �������� �� ������� ������
extern string Setup_TrailByMA       = "-------------- N8 - TrailingByMA --------------";
extern int    MA_Period                = 14;        // 2-infinity, ����� �����
extern int    MA_Shift                 = 0;         // ����� ������������� ��� ������������� �����, � ����� 0
extern int    MA_Method                = 1;         // 0 (MODE_SMA), 1 (MODE_EMA), 2 (MODE_SMMA), 3 (MODE_LWMA)
extern int    MA_Price                 = 0;         // 0 (PRICE_CLOSE), 1 (PRICE_OPEN), 2 (PRICE_HIGH), 3 (PRICE_LOW), 4 (PRICE_MEDIAN), 5 (PRICE_TYPICAL), 6 (PRICE_WEIGHTED)
extern int    MA_Bar                   = 0;         // 0-Bars, ����� �����
extern int    Indent_MA                = 10;        // 0-infinity, ����� �����
extern string Setup_TrailFiftyFifty = "----------- N9 - TrailingFiftyFifty -----------";
extern double FF_coeff                 = 0.05;      // "����������� ��������", � % �� 0.01 �� 1 (� ��������� ������ SL ����� ��������� (���� ���������) �������� � ���. ����� � �������, ������ �����, ����� �� ���������)
extern string Setup_TrailKillLoss   = "----------- N10 - TrailingKillLoss ------------";
extern double SpeedCoeff               = 0.5;       // "��������" �������� �����
extern string Setup_TrailPips       = "--------------- N11 - TrailPips ---------------";
extern int    Average_Period           = PERIOD_D1; // �� ����� ������� ��������� ������� �����
//IIIIIIIIIIIIIIIIIII=========����������� ������� �������=======IIIIIIIIIIIIIIIIIIIIII+
#include <stdlib.mqh>                               // ���������� ����������� ������
//IIIIIIIIIIIIIIIIIII========���������� ���������� ������========IIIIIIIIIIIIIIIIIIIII+
double gd_TrailStop, gd_TrailStep, bda_ProfitLevel[3], bd_ProfitMIN;
bool   bb_VirtualTrade = false, bb_TrailLOSS;
string bs_fName, bs_FileName;
int    bi_NumberOfTries = 10,      // ���������� ������� �� ����������� ������
       bi_RetryTime = 500,         // ������� ����������� ����� �\� ��������� ���������
       bia_StopLevel[3];
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//       ����������� ���������� �������.                                              |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
void fTrail_Position (int fi_Ticket)
{
    static bool lb_first = true;
    double ld_NewSL = 0.0, ld_Price;
    bool   lb_Trail = false;
//----
    //---- ��� ������ ������� ��������� �������� ������� ����������
    // � ��������� ������������ ������������ � ������� ����������
    if (lb_first)
    {
        if (!fCheck_TrailParameters())
        {
            Alert ("��������� ��������� ���������� ���� ��������� !!!");
            return;
        }
        else
        {lb_first = false;}
    }
    if (TrailLOSS_ON && iBarShift (Symbol(), 0, OrderOpenTime()) > TrailLossAfterBar)
    {bb_TrailLOSS = true;}
    else
    {bb_TrailLOSS = false;}
    bs_fName = "";
    //---- ������������ ��������� ����� ���������
    switch (N_Trailing)
    {
        case 1: // �������� �� ���������
            bs_fName = "TrailingByFractals()";
            lb_Trail = TrailingByFractals (fi_Ticket, ld_NewSL);
            break;
        case 2: // �������� �� ����� N ������
            bs_fName = "TrailingByShadows()";
            lb_Trail = TrailingByShadows (fi_Ticket, ld_NewSL);
            break;
        case 3: // �������� �����������-"������"
            bs_fName = "TrailingUdavka()";
            lb_Trail = TrailingUdavka (fi_Ticket, ld_NewSL);
            break;
        case 4: // �������� �� �������
            bs_fName = "TrailingByTime()";
            lb_Trail = TrailingByTime (fi_Ticket, ld_NewSL);
            break;
        case 5: // �������� �� ATR
            bs_fName = "TrailingByATR()";
            lb_Trail = TrailingByATR (fi_Ticket, ld_NewSL);
            break;
        case 6: // �������� RATCHET �����������
            bs_fName = "TrailingRatchetB()";
            lb_Trail = TrailingRatchetB (fi_Ticket, ld_NewSL);
            break;
        case 7: // �������� �� ������� ������
            bs_fName = "TrailingByPriceChannel()";
            lb_Trail = TrailingByPriceChannel (fi_Ticket, ld_NewSL);
            break;
        case 8: // �������� �� ����������� ��������
            bs_fName = "TrailingByMA()";
            lb_Trail = TrailingByMA (fi_Ticket, ld_NewSL);
            break;
        case 9: // �������� "�����������"
            bs_fName = "TrailingFiftyFifty()";
            lb_Trail = TrailingFiftyFifty (fi_Ticket, ld_NewSL);
            break;
        case 10: // �������� KillLoss
            bs_fName = "KillLoss()";
            lb_Trail = KillLoss (fi_Ticket, ld_NewSL);
            break;
        case 11: // �������� "�����������"
            bs_fName = "TrailPips()";
            lb_Trail = TrailPips (fi_Ticket, ld_NewSL);
            break;
        default: // �����������-������������
            bs_fName = "TrailingStairs()";
            lb_Trail = TrailingStairs (fi_Ticket, ld_NewSL);
            break;
    }
    //---- ������������ ��������
    if (lb_Trail)
    {
        //---- ��������� �� ����� GV-����������
        fClear_GV();
        double ld_MinSTOP = NDPm (MarketInfo (Symbol(), MODE_STOPLEVEL));
        //---- ����������� ����� SL �� ���������� ���������
        if (OrderType() == OP_BUY) {ld_NewSL = MathMin (ld_NewSL, Bid - ld_MinSTOP);}
        else {ld_NewSL = MathMax (ld_NewSL, Ask + ld_MinSTOP);}
        double ld_SL = NormalizeDouble (OrderStopLoss(), 4);
        ld_NewSL = NormalizeDouble (ld_NewSL, 4);
        //---- SL ����� � ������� ���������� ������
        if ((((ld_NewSL > ld_SL && OrderType() == OP_BUY)
        || (ld_NewSL < ld_SL && OrderType() == OP_SELL)) || OrderStopLoss() == 0)
        && fCheck_MinProfit (ProfitMIN, ld_NewSL))
        {fOrder_Modify (fi_Ticket, ld_Price, ld_NewSL, OrderTakeProfit(), 0, Gold);}
    }
//----
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//       ��������� ���������� � ������� ������� ���������.                            |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool fCheck_TrailParameters()
{
    int li_Decimal = 1;
//----
    if (Trail_Period == 0) {Trail_Period = Period();}
    //---- �� ��������� ������� ���� �������� ������ �����
    if (TrailLossAfterBar == 0)
    {TrailLossAfterBar = PERIOD_D1 / Period();}
    //---- ���� ���������� ��������� ���� � ����
    if (IsOptimization() || IsTesting())
    {
        bb_VirtualTrade = true;
        //---- ��������� �������� ���������� GV-����������
        fClear_preGV();
    }
    //---- ��������� ��� ����� ��� ����
    bs_FileName = StringConcatenate (WindowExpertName(), "_", Symbol(), "_", Period(), "-", Month(), "-", Day(), ".log");
    //---- ���������� �������� ������������ �������� ������������� ����������
    if (fGet_NumPeriods (Trail_Period) < 0)
    {
        Alert ("�� ��������� ����� ������ (���������� Trail_Period) !!!");
        return (false);
    }
    if (TrailLOSS_ON && TrailLossAfterBar < 0)
    {
        Print ("��������� TrailLossAfterBar >= 0 !!!");
        return (false);
    }
    if (TrailStep < 1 && (N_Trailing == 0 || N_Trailing == 10 || N_Trailing == 11))
    {
        Print ("��������� TrailStep >= 1 !!!");
        return (false);
    }
    if ((TrailingStop < TrailStep || TrailingStop < BreakEven || BreakEven < 0) && N_Trailing == 0)
    {
        Print ("�������� �������� TrailingStairs() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((BarsInFractal <= 3 || Indent_Fr < 0) && N_Trailing == 1)
    {
        Print ("�������� �������� TrailingByFractals() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((BarsToShadows < 1 || Indent_Sh < 0) && N_Trailing == 2)
    {
        Print ("�������� �������� TrailingByShadows() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((Level_1 >= Distance_1 || Level_2 >= Level_1 || Level_3 >= Level_2 || Distance_1 >= Distance_2) && N_Trailing == 3)
    {
        Print ("�������� �������� TrailingUdavka() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((Interval < 1 || TimeStep < 1) && N_Trailing == 4)
    {
        Print ("�������� �������� TrailingByTime() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((ATR_Period1 < 1 || ATR_Period2 < 1 || ATR_coeff <= 0) && N_Trailing == 5)
    {
        Print ("�������� �������� TrailingByATR() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((ProfitLevel_2 <= ProfitLevel_1 || ProfitLevel_3 <= ProfitLevel_2 || ProfitLevel_3 <= ProfitLevel_1) && N_Trailing == 6)
    {
        Print ("�������� �������� TrailingRatchetB() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((BarsInChannel < 1 || Indent_Pr < 0) && N_Trailing == 7)
    {
        Print ("�������� �������� TrailingByPriceChannel() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((MA_Period < 2 || MA_Method < 0 || MA_Method > 3 || MA_Price < 0 || MA_Price > 6 || MA_Bar < 0 || Indent_MA < 0) && N_Trailing == 8)
    {
        Print ("�������� �������� TrailingByMA() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if ((FF_coeff < 0.01 || FF_coeff > 1.0) && N_Trailing == 9)
    {
        Print ("�������� �������� TrailingFiftyFifty() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    if (SpeedCoeff < 0.1 && N_Trailing == 10)
    {
        Print ("�������� �������� KillLoss() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (0);
    }
    if (Average_Period <= Period() && N_Trailing == 11)
    {
        Print ("�������� �������� TrailPips() ���������� ��-�� �������������� �������� ���������� �� ����������.");
        return (false);
    }
    //---- �������� ������� ���������� � ������������ � ������������ ��������� ��
    if (Digits == 3 || Digits == 5)
    {li_Decimal = 10;}
    ProfitMIN *= li_Decimal;
    bd_ProfitMIN = NDPm (ProfitMIN);
    TrailingStop *= li_Decimal;
    TrailStep *= li_Decimal;
    BreakEven *= li_Decimal;
    Indent_Fr *= li_Decimal;
    Indent_Sh *= li_Decimal;
    Indent_Pr *= li_Decimal;
    Indent_MA *= li_Decimal;
    Distance_1 *= li_Decimal;
    Distance_2 *= li_Decimal;
    Level_1 *= li_Decimal;
    Level_2 *= li_Decimal;
    Level_3 *= li_Decimal;
    TimeStep *= li_Decimal;
    ProfitLevel_1 *= li_Decimal;
    StopLevel_1 *= li_Decimal;
    ProfitLevel_2 *= li_Decimal;
    StopLevel_2 *= li_Decimal;
    ProfitLevel_3 *= li_Decimal;
    StopLevel_3 *= li_Decimal;
    bda_ProfitLevel[0] = NDPm (ProfitLevel_1);
    bia_StopLevel[0] = StopLevel_1;
    bda_ProfitLevel[1] = NDPm (ProfitLevel_2);
    bia_StopLevel[1] = StopLevel_2;
    bda_ProfitLevel[2] = NDPm (ProfitLevel_3);
    bia_StopLevel[2] = StopLevel_3;
//----
     return (true);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �� ���������                                                             |
//| ������� ��������� ����� �������, ���������� ����� � ��������, � ������ (�������) |
//| - ���������� �� ����. (���.) �����, �� ������� ����������� �������� (�� 0),       |
//|  trlinloss - ������� �� � ���� �������                                            |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByFractals (int fi_Ticket, double& fd_NewSL)
{
    int    i, z,             // counters
           li_ExtremN,       // ����� ���������� ���������� frktl_bars-������� �������� 
           after_x, be4_x,   // ������ ����� � �� ���� ��������������
           ok_be4, ok_after, // ����� ������������ ������� (1 - �����������, 0 - ���������)
           lia_PeakN[2];     // ������ ����������� ��������� ��������� �� �������/������� ��������������   
    double ld_Indent = NDPm (Indent_Fr),
           ld_tmp;           // ��������� ����������
//----
    ld_tmp = BarsInFractal;
    if (MathMod (BarsInFractal, 2) == 0) {li_ExtremN = ld_tmp / 2;}
    else {li_ExtremN = MathRound (ld_tmp / 2);}
    //---- ����� �� � ����� ���������� ��������
    after_x = BarsInFractal - li_ExtremN;
    if (MathMod (BarsInFractal, 2) != 0) {be4_x = BarsInFractal - li_ExtremN;}
    else {be4_x = BarsInFractal - li_ExtremN - 1;}
    //---- ���� OP_BUY, ������� ��������� ������� �� ������� (�.�. ��������� "����")
    if (OrderType() == OP_BUY)
    {
        //---- ������� ��������� ������� �� �������
        for (i = li_ExtremN; i < iBars (Symbol(), Trail_Period); i++)
        {
            ok_be4 = 0;
            ok_after = 0;
            for (z = 1; z <= be4_x; z++)
            {
                if (iLow (Symbol(), Trail_Period, i) >= iLow (Symbol(), Trail_Period, i - z)) 
                {
                    ok_be4 = 1;
                    break;
                }
            }
            for (z = 1; z <= after_x; z++)
            {
                if (iLow (Symbol(), Trail_Period, i) > iLow (Symbol(), Trail_Period, i + z)) 
                {
                    ok_after = 1;
                    break;
                }
            }            
            if (ok_be4 == 0 && ok_after == 0)                
            {
                lia_PeakN[1] = i; 
                break;
            }
        }
        //---- ��������� ������� �� ���� �������
        double ld_Peak = iLow (Symbol(), Trail_Period, lia_PeakN[1]);
        //---- ���� ����� �������� ����� ���������� (� �.�. ���� �������� == 0, �� ���������)
        if ((ld_Peak - ld_Indent > OrderStopLoss())
        && (bb_TrailLOSS || (!TrailLOSS_ON && ld_Peak - ld_Indent > OrderOpenPrice())))
        {
            fd_NewSL = ld_Peak - ld_Indent;
            return (true);
        }
    }
    //---- ���� OP_SELL, ������� ��������� ������� �� ������� (�.�. ��������� "�����")
    if (OrderType() == OP_SELL)
    {
        //---- ������� ��������� ������� �� �������
        for (i = li_ExtremN; i < iBars (Symbol(), Trail_Period); i++)
        {
            ok_be4 = 0;
            ok_after = 0;
            for (z = 1; z <= be4_x; z++)
            {
                if (iHigh (Symbol(), Trail_Period, i) <= iHigh (Symbol(), Trail_Period, i - z)) 
                {
                    ok_be4 = 1;
                    break;
                }
            }
            for (z = 1; z <= after_x; z++)
            {
                if (iHigh (Symbol(), Trail_Period, i) < iHigh (Symbol(), Trail_Period, i + z)) 
                {
                    ok_after = 1;
                    break;
                }
            }            
            if (ok_be4 == 0 && ok_after == 0)                
            {
                lia_PeakN[0] = i;
                break;
            }
        }        
        ld_Peak = iHigh (Symbol(), Trail_Period, lia_PeakN[0]);
        ld_Indent += NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        //---- ���� ����� �������� ����� ���������� (� �.�. ���� �������� == 0, �� ���������)
        if ((ld_Peak + ld_Indent < OrderStopLoss() || OrderStopLoss() == 0)
        && (bb_TrailLOSS || (!TrailLOSS_ON && ld_Peak + ld_Indent < OrderOpenPrice())))
        {
            fd_NewSL = ld_Peak + ld_Indent;
            return (true);
        }
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �� ����� N ������                                                        |
//| ������� ���������� ���������� �����, �� ����� ������� ���������� �������������    |
//| (�� 1 � ������) � ������ (�������) - ���������� �� ����. (���.) �����, ��         |
//| ������� ����������� �������� (�� 0), TrailLOSS_ON - ������� �� � �����            |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByShadows (int fi_Ticket, double& fd_NewSL)
{
    double ld_Extremum, ld_Indent = NDPm (Indent_Sh);
//----
    //---- ���� ������� ������� (OP_BUY), ������� ������� BarsToShadows ������
    if (OrderType() == OP_BUY)
    {
        ld_Extremum = iLow (Symbol(), Trail_Period, iLowest (Symbol(), Trail_Period, MODE_LOW, BarsToShadows, 1));
        if ((ld_Extremum - ld_Indent > OrderStopLoss())
        && (bb_TrailLOSS || (!TrailLOSS_ON && ld_Extremum - ld_Indent > OrderOpenPrice())))
        {
            fd_NewSL = ld_Extremum - ld_Indent;
            return (true);
        }
    }
    //---- ���� OP_SELL, ������� �������� BarsToShadows ������
    if (OrderType() == OP_SELL)
    {
        ld_Extremum = iHigh (Symbol(), Trail_Period, iHighest (Symbol(), Trail_Period, MODE_HIGH, BarsToShadows, 1));
        ld_Indent += NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        //---- ���� ����� �������� ����� ���������� (� �.�. ���� �������� == 0, �� ���������)
        if ((ld_Extremum + ld_Indent < OrderStopLoss() || OrderStopLoss() == 0)
        && (bb_TrailLOSS || (!TrailLOSS_ON && ld_Extremum + ld_Indent < OrderOpenPrice())))
        {
            fd_NewSL = ld_Extremum + ld_Indent;
            //Print ("New SL = ", DSDm (fd_NewSL), "; SL[", DS0 ((OrderStopLoss() - fd_NewSL) / Point), "] = ", DSDm (OrderStopLoss()), "; OpenPrice[", DS0 ((fd_NewSL - OrderOpenPrice()) / Point), "] = ", DSDm (OrderOpenPrice()), "; Price[", DS0 ((fd_NewSL - Bid) / Point), "] = ", DSDm (Bid));
            return (true);
        }
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �����������-������������                                                 |
//| ������� ��������� ����� �������, ���������� �� ����� ��������, �� �������        |
//| �������� ����������� (�������) � "���", � ������� �� ����������� (�������)        |
//| ������: ��� +30 ���� �� +10, ��� +40 - ���� �� +20 � �.�.                         |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingStairs (int fi_Ticket, double& fd_NewSL)
{
    double ld_Price;
//----
    gd_TrailStop = NDPm (TrailingStop);
    gd_TrailStep = NDPm (TrailStep);
    //---- ���� ������� ������� (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        //---- ����������� ������ �� ��� �������
        if (BreakEven > 0)
        {
            if ((ld_Price - OrderOpenPrice()) > NDPm (BreakEven))
            {
                //---- ����������� ������ � �� ����������� ���� ���
                if ((OrderStopLoss() - OrderOpenPrice()) < 0)
                {
                    fd_NewSL = OrderOpenPrice() + bd_ProfitMIN;
                    return (true);
                }
            }    
        }
        if (TrailingStop > 0)
        {
            if (ld_Price - OrderOpenPrice() > gd_TrailStop)
            {
                if (OrderStopLoss() < ld_Price - (gd_TrailStop + gd_TrailStep))
                {
                    fd_NewSL = ld_Price - gd_TrailStop;
                    return (true);
                }
            }
        }
    }
    //---- ���� �������� ������� (OP_SELL)
    if (OrderType() == OP_SELL)
    { 
        ld_Price = Ask;
        double ld_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        gd_TrailStop += ld_Spread;
        //---- ����������� ������ �� ��� �������
        if (BreakEven > 0)
        {
            if ((OrderOpenPrice() - ld_Price) > NDPm (BreakEven) + ld_Spread)
            {
                //---- ����������� ������ � �� ����������� ���� ���
                if ((OrderOpenPrice() - OrderStopLoss()) < 0)
                {
                    fd_NewSL = OrderOpenPrice() - bd_ProfitMIN;
                    return (true);
                }
            }
        }
        if (TrailingStop > 0)
        {
            if (OrderOpenPrice() - ld_Price > gd_TrailStop)
            {
                if (OrderStopLoss() > ld_Price + (gd_TrailStop + gd_TrailStep) || OrderStopLoss() == 0)
                {
                    fd_NewSL = ld_Price + gd_TrailStop;
                    return (true);
                }
            }
        }
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �����������-"������"                                                     |
//| ������: �������� �������� 30 �., ��� +50 - 20 �., +80 >= - �� ���������� � 10 �.  |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingUdavka (int fi_Ticket, double& fd_NewSL)
{
    double ld_Price, ld_MovePrice;
//----
    gd_TrailStep = NDPm (TrailStep);
    gd_TrailStop = 0.0;
    //---- ���� ������� ������� (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        ld_MovePrice = ld_Price - OrderOpenPrice();
        if (ld_MovePrice <= 0)
        {return (false);}
        //---- ���������� ���������� �� ����� �� ���� (��������� ������ ���������)
        if (ld_MovePrice <= NDPm (Distance_1)) {gd_TrailStop = Level_1;}
        if (ld_MovePrice > NDPm (Distance_1) && ld_MovePrice <= NDPm (Distance_2))
        {gd_TrailStop = Level_2;}
        if (ld_MovePrice > NDPm (Distance_2)) {gd_TrailStop = Level_3;}
        gd_TrailStop *= Point;
        //---- ���� �������� = 0 ��� ������ ����� ��������, �� ���� ���.���� (Bid) ������/����� ��������� ����_�������� + �����.���������
        if (OrderStopLoss() < OrderOpenPrice())
        {
            if (ld_MovePrice > gd_TrailStop + gd_TrailStep)
            {
                fd_NewSL = ld_Price - gd_TrailStop;
                return (true);
            }
        }
        //---- �����: ���� ������� ���� (Bid) ������/����� ��������� �������_�������� + ���������� ���������, 
        else
        {
            if (ld_Price - OrderStopLoss() > gd_TrailStop + gd_TrailStep)
            {
                fd_NewSL = ld_Price - gd_TrailStop;
                return (true);
            }
        }
    }
    //---- ���� �������� ������� (OP_SELL)
    if (OrderType() == OP_SELL)
    { 
        double gd_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        ld_Price = Ask;
        ld_MovePrice = OrderOpenPrice() - (ld_Price + gd_Spread);
        if (ld_MovePrice <= 0)
        {return (false);}
        //---- ���������� ���������� �� ����� �� ���� (��������� ������ ���������)
        if (ld_MovePrice <= NDPm (Distance_1)) {gd_TrailStop = Level_1;}
        if (ld_MovePrice > NDPm (Distance_1) && ld_MovePrice <= NDPm (Distance_2))
        {gd_TrailStop = Level_2;}
        if (ld_MovePrice > NDPm (Distance_2)) {gd_TrailStop = Level_3;}
        gd_TrailStop *= Point;
        // ���� �������� = 0 ��� ������ ����� ��������, �� ���� ���.���� (Ask) ������/����� ��������� ����_��������+�����.���������
        if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice())
        {
            if (ld_MovePrice > gd_TrailStop + gd_TrailStep)
            {
                fd_NewSL = ld_Price + gd_TrailStop;
                return (true);
            }
        }
        //---- �����: ���� ������� ���� (Bid) ������/����� ��������� �������_�������� + ���������� ���������, 
        else
        {
            if (OrderStopLoss() - (ld_Price + gd_Spread) > gd_TrailStop + gd_TrailStep)
            {
                fd_NewSL = ld_Price + gd_TrailStop;
                return (true);
            }
        }
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �� �������                                                               |
//| ������� ��������� ����� �������, �������� (�����), � �������, �������������      |
//| �������� � ��� ��������� (�� ������� ������� ������������ ��������, TrailLOSS_ON  |
//| - ������ �� � ������ (�.�. � ����������� ���������� ����������� ���� �� �����    |
//| ��������, � ����� � � �������, ���� ������ � �������)                             |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByTime (int fi_Ticket, double& fd_NewSL)
{
    int    li_MinPast;    // ���-�� ������ ����� �� �������� ������� �� �������� ������� 
    double times2change;  // ���-�� ���������� Interval � ������� �������� ������� (�.�. ������� ��� ������ ��� ���� ��������� ��������) 
//----
    //---- ����������, ������� ������� ������ � ������� �������� �������
    li_MinPast = (TimeCurrent() - OrderOpenTime()) / 60;
    //---- ������� ��� ����� ���� ����������� ��������
    times2change = MathFloor (li_MinPast / Interval);
    //---- ���� ������� ������� (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        //---- ���� ������ � ������, �� ��������� �� ��������� (���� �� �� 0, ���� 0 - �� ��������)
        if (bb_TrailLOSS)
        {
            if (OrderStopLoss() == 0) {fd_NewSL = OrderOpenPrice() + times2change * NDPm (TimeStep);}
            else {fd_NewSL = OrderStopLoss() + times2change * NDPm (TimeStep);}
        }
        //---- ����� - �� ����� �������� �������
        else
        {fd_NewSL = OrderOpenPrice() + times2change * NDPm (TimeStep);}
    }
    //---- ���� �������� ������� (OP_SELL)
    if (OrderType() == OP_SELL)
    {
        double gd_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        //---- ���� ������ � ������, �� ��������� �� ��������� (���� �� �� 0, ���� 0 - �� ��������)
        if (bb_TrailLOSS)
        {
            if (OrderStopLoss() == 0) {fd_NewSL = OrderOpenPrice() - times2change * NDPm (TimeStep) - gd_Spread;}
            else {fd_NewSL = OrderStopLoss() - times2change * NDPm (TimeStep) - gd_Spread;}
        }
        else
        {fd_NewSL = OrderOpenPrice() - times2change * NDPm (TimeStep) - gd_Spread;}
    }
    if (times2change > 0)
    {return (true);}
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �� ATR (Average True Range, ������� �������� ��������)                   |
//| ������� ��������� ����� �������, ������ ��R � �����������, �� ������� ���������� |
//| ATR. �.�. �������� "�������" �� ���������� ATR � N �� �������� �����;             |
//| ������� - �� ����� ���� (�.�. �� ���� �������� ���������� ����)                   |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByATR (int fi_Ticket, double& fd_NewSL)
{
    double ld_ATR, ld_Price,
           ld_Coeff; // ��������� ��������� �������� �� ATR �� �����������
//----
    //---- ������� �������� ATR
    ld_ATR = iATR (Symbol(), Trail_Period, ATR_Period1, ATR_shift1);
    ld_ATR = MathMax (ld_ATR, iATR (Symbol(), Trail_Period, ATR_Period2, ATR_shift2));
    //---- ����� ��������� �� �����������
    ld_Coeff = ld_ATR * ATR_coeff;
    //---- ���� ������� ������� (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        //---- ����������� �� �������� ����� (����� ��������)
        fd_NewSL = ld_Price - ld_Coeff;
        //---- ���� TrailLOSS_ON == true (�.�. ������� ������� � ���� ������), ��
        if ((bb_TrailLOSS && fd_NewSL > OrderStopLoss())
        //---- ����� ������ �� ����� ��������
        || (!TrailLOSS_ON && fd_NewSL > OrderOpenPrice()))
        {return (true);}
    }
    //---- ���� �������� ������� (OP_SELL)
    if (OrderType() == OP_SELL)
    {
        ld_Price = Ask;
        //---- ����������� �� �������� ����� (����� ��������)
        fd_NewSL = ld_Price + (ld_Coeff + NDPm (MarketInfo (Symbol(), MODE_SPREAD)));
        //---- ���� TrailLOSS_ON == true (�.�. ������� ������� � ���� ������), ��
        if ((bb_TrailLOSS && (fd_NewSL < OrderStopLoss() || OrderStopLoss() == 0))
        //---- ����� ������ �� ����� ��������
        || (!TrailLOSS_ON && fd_NewSL < OrderOpenPrice()))
        {return (true);}
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� RATCHET �����������                                                      |
//| ��� ���������� �������� ������ 1 �������� - � +1, ��� ���������� �������� ������  |
//| 2 ������� - �������� - �� ������� 1, ����� ������ ��������� ������ 3 �������,     |
//| �������� - �� ������� 2 (������ ����� �������� ������� ��������)                  |
//| ��� ������ � �������� ������� - ���� 3 ������, �� ����� ������ � ���� ���������   |
//| ����,  � ������: ���� �� ���������� ���� ������, � ����� ��������� ���� ����      |
//| (������ ��� �������), �� �������� ������ �� ���������, ����� �������� �������     |
//| (��������, ������ -5, -10 � -25, �������� -40; ���� ���������� ���� -10, � �����  |
//| ��������� ���� -10, �� �������� - �� -25, ���� ���������� ���� -5, �� ��������    |
//| ��������� �� -10, ��� -2 (�����) ���� �� -5                                       |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingRatchetB (int fi_Ticket, double& fd_NewSL)
{
    bool lb_result = false;
    double ld_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
//----
    //---- ���� ������� ������� (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        double dBid = Bid, ld_ProfitLevel;
        //---- �������� �� ������� ��������
        for (int li_IND = 2; li_IND >= 0; li_IND--)
        {
            //---- ���� ������� "�������_����-����_��������" > "ProfitLevel_N+�����", SL ��������� � "ProfitLevel_N-1+�����"
            if (dBid - OrderOpenPrice() >= bda_ProfitLevel[li_IND])
            {
                if (li_IND == 0) {ld_ProfitLevel = NDPm (ProfitMIN);} else {ld_ProfitLevel = bda_ProfitLevel[li_IND-1];}
                if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice() + ld_ProfitLevel)
                {
                    fd_NewSL = OrderOpenPrice() + ld_ProfitLevel;
                    return (true);
                }
            }
        }
        //---- �������� �� ������� ������
        if (bb_TrailLOSS)      
        {
            //---- ��������� �� ����� ������������ ���������� ����������
            double ld_LastLossLevel;
            string ls_Name = StringConcatenate (fi_Ticket, "_#LastLossLevel");
            //---- ���������� ���������� ��������� �������� �������� ������ ������ ������ (StopLevel_n), ���� �������� ��������� ����
            // (���� �� ����� ����� ����������� ����, ������������� SL �� ��������� ����� �������� ������ ������ (���� ��� �� ��������� SL �������)
            if (!GlobalVariableCheck (ls_Name))
            {GlobalVariableSet (ls_Name, 0);}
            else
            {ld_LastLossLevel = GlobalVariableGet (ls_Name);}
            //---- ��������� ������� ������� ���� ����� �������� � �� ������� ������ �������
            if (dBid - OrderOpenPrice() < NDPm (ProfitLevel_1))
            {
                //---- ���� (�������_���� �����/����� ��������) � (dpstlslvl>=StopLevel_1), �������� - �� StopLevel_1
                if (dBid >= OrderOpenPrice())
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice() - NDPm (StopLevel_1))
                    {
                        fd_NewSL = OrderOpenPrice() - NDPm (StopLevel_1);
                        lb_result = true;
                    }
                }
                //---- ���� (�������_���� ����� ������_������_1) � (dpstlslvl>=StopLevel_1), �������� - �� StopLevel_2
                if (dBid >= OrderOpenPrice() - NDPm (StopLevel_1) && ld_LastLossLevel >= StopLevel_1)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice() - NDPm (StopLevel_2))
                    {
                        fd_NewSL = OrderOpenPrice() - NDPm (StopLevel_2);
                        lb_result = true;
                    }
                }
                //---- ���� (�������_���� ����� ������_������_2) � (dpstlslvl>=StopLevel_2), �������� - �� StopLevel_3
                if (dBid >= OrderOpenPrice() - NDPm (StopLevel_2) && ld_LastLossLevel >= StopLevel_2)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice() - NDPm (StopLevel_3))
                    {
                        fd_NewSL = OrderOpenPrice() - NDPm (StopLevel_3);
                        lb_result = true;
                    }
                }
                //---- ��������/������� �������� �������� �������� "������" �������� "���������"
                //---- ���� "�������_����-���� �������� + �����" ������ 0, 
                if (dBid - OrderOpenPrice() + ld_Spread < 0)
                //---- ��������, �� ������ �� �� ���� ��� ����� ������ ������
                {
                    for (li_IND = 2; li_IND >= 0; li_IND--)
                    {
                        if (dBid <= OrderOpenPrice() - NDPm (bia_StopLevel[li_IND]))
                        {
                            if (ld_LastLossLevel < bia_StopLevel[li_IND])
                            {
                                GlobalVariableSet (ls_Name, bia_StopLevel[li_IND]);
                                return (lb_result);
                            }
                        }
                    }
                }
            }
        }
    }
    //---- ���� �������� ������� (OP_SELL)
    if (OrderType() == OP_SELL)
    {
        double dAsk = Ask;
        //---- �������� �� ������� ��������
        //---- ���� ������� "�������_����-����_��������" > "ProfitLevel_3+�����", SL ��������� � "ProfitLevel_2+�����"
        for (li_IND = 2; li_IND >= 0; li_IND--)
        {
            //---- ���� ������� "�������_����-����_��������" > "ProfitLevel_N+�����", SL ��������� � "ProfitLevel_N-1+�����"
            if (OrderOpenPrice() - dAsk >= bda_ProfitLevel[li_IND])
            {
                if (li_IND == 0) {ld_ProfitLevel = ld_Spread + NDPm (ProfitMIN);} else {ld_ProfitLevel = bda_ProfitLevel[li_IND-1] + ld_Spread;}
                if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice() - ld_ProfitLevel)
                {
                    fd_NewSL = OrderOpenPrice() - ld_ProfitLevel;
                    return (true);
                }
            }
        }
        //---- �������� �� ������� ������
        if (bb_TrailLOSS)      
        {
            //---- ��������� �� ����� ������������ ���������� ����������
            ls_Name = StringConcatenate (fi_Ticket, "_#LastLossLevel");
            //---- ���������� ���������� ��������� �������� �������� ������ ������ ������ (StopLevel_n), ���� �������� ��������� ����
            // (���� �� ����� ����� ����������� ����, ������������� SL �� ��������� ����� �������� ������ ������ (���� ��� �� ��������� SL �������)
            if (!GlobalVariableCheck (ls_Name))
            {GlobalVariableSet (ls_Name, 0);}
            else
            {ld_LastLossLevel = GlobalVariableGet (ls_Name);}
            //---- ��������� ������� ������� ���� ����� �������� � �� ������� ������ �������
            if (OrderOpenPrice() - dAsk < NDPm (ProfitLevel_1))         
            {
                //---- ���� (�������_���� �����/����� ��������) � (dpstlslvl>=StopLevel_1), SL - �� StopLevel_1
                if (dAsk <= OrderOpenPrice())
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice() + (NDPm (StopLevel_1) + ld_Spread))
                    {
                        fd_NewSL = OrderOpenPrice() + (NDPm (StopLevel_1) + ld_Spread);
                        lb_result = true;
                    }
                }
                //---- ���� (�������_���� ����� ������_������_1) � (dpstlslvl>=StopLevel_1), SL - �� StopLevel_2
                if (dAsk <= OrderOpenPrice() + (NDPm (StopLevel_1) + ld_Spread) && ld_LastLossLevel >= StopLevel_1)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice() + (NDPm (StopLevel_2) + ld_Spread))
                    {
                        fd_NewSL = OrderOpenPrice() + (NDPm (StopLevel_2) + ld_Spread);
                        lb_result = true;
                    }
                }
                //---- ���� (�������_���� ����� ������_������_2) � (dpstlslvl>=StopLevel_2), SL - �� StopLevel_3
                if (dAsk <= OrderOpenPrice() + (NDPm (StopLevel_2) + ld_Spread) && ld_LastLossLevel >= StopLevel_2)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice() + (NDPm (StopLevel_3) + ld_Spread))
                    {
                        fd_NewSL = OrderOpenPrice() + (NDPm (StopLevel_3) + ld_Spread);
                        lb_result = true;
                    }
                }
                //---- ��������/������� �������� �������� �������� "������" �������� "���������"
                //---- ���� "�������_����-���� ��������+�����" ������ 0, 
                if (OrderOpenPrice() - dAsk + ld_Spread < 0)
                //---- ��������, �� ������ �� �� ���� ��� ����� ������ ������
                {
                    for (li_IND = 2; li_IND >= 0; li_IND--)
                    {
                        if (dAsk >= OrderOpenPrice() + (NDPm (bia_StopLevel[li_IND]) + ld_Spread))
                        {
                            if (ld_LastLossLevel < bia_StopLevel[li_IND])
                            {
                                GlobalVariableSet (ls_Name, bia_StopLevel[li_IND]);
                                return (lb_result);
                            }
                        }
                    }
                }
            }
        }
    }
//----
    return (lb_result);    
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �� ������� ������                                                        |
//| �������� �� ������ Nickolay Zhilin (aka rebus) �������� �� ����������� �����.     |
//| ������� ��������� ����� �������, ������ (���-�� �����) ��� �������� ������� �    | 
//| ������ ������ ������, ������ (�������), �� ������� ����������� �������� ��        |
//| ������� ������                                                                    |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByPriceChannel (int fi_Ticket, double& fd_NewSL)
{     
    double ld_ChnlMax, // ������� ������� ������
           ld_ChnlMin; // ������ ������� ������
//----
    //---- ���������� ����.��� � ���.��� �� BarsInChannel ����� ������� � [1] (= ������� � ������ ������� �������� ������)
    ld_ChnlMax = iHigh (Symbol(), Trail_Period, iHighest (Symbol(), Trail_Period, MODE_HIGH, BarsInChannel, 1)) + NDPm ((Indent_Pr + MarketInfo (Symbol(), MODE_SPREAD)));
    ld_ChnlMin = iLow (Symbol(), Trail_Period, iLowest (Symbol(), Trail_Period, MODE_LOW, BarsInChannel, 1)) - NDPm (Indent_Pr);   
   
    //---- ���� ������� �������, � � �������� ���� (���� ������ ������� ������ ���� �� ���������, == 0), ������������ ���
    if (OrderType() == OP_BUY)
    {
        if (OrderStopLoss() < ld_ChnlMin)
        {
            fd_NewSL = ld_ChnlMin;
            return (true);
        }
    }
    //---- ���� ������� - ��������, � � �������� ���� (���� ������� ������� ������ ��� �� ��������, == 0), ������������ ���
    if (OrderType() == OP_SELL)
    {
        if (OrderStopLoss() == 0 || OrderStopLoss() > ld_ChnlMax)
        {
            fd_NewSL = ld_ChnlMax;
            return (true);
        }
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� �� ����������� ��������                                 |
//| ������� ��������� ����� ������� � ��������� ������� (���������, | 
//| ������, ���, ����� ������������ �������, ����� �����������,      |
//| ������������ OHCL ��� ����������, � ����, �� ������� �������     |
//| �������� �������.                                                |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByMA (int fi_Ticket, double& fd_NewSL)
{     
    double ld_MA; // �������� ����������� �������� � ����������� �����������
   
    //---- ��������� �������� �� � ����������� ������� �����������
    ld_MA = iMA (Symbol(), Trail_Period, MA_Period, MA_Shift, MA_Method, MA_Price, MA_Bar);
    //---- ���� ������� �������, � � �������� ���� �������� �������� � �������� � Indent_MA �������, ������������ ���
    if (OrderType() == OP_BUY)
    {
        if (OrderStopLoss() < ld_MA - NDPm (Indent_MA))
        {
            fd_NewSL = ld_MA - NDPm (Indent_MA);
            return (true);
        }
    }
    //---- ���� ������� - ��������, � � �������� ���� (���� ������� ������� ������ ��� �� ��������, ==0), ������������ ���
    if (OrderType() == OP_SELL)
    {
        double ld_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        if (OrderStopLoss() == 0 || OrderStopLoss() > ld_MA + (NDPm (Indent_MA) + ld_Spread))
        {
            fd_NewSL = ld_MA + (NDPm (Indent_MA) + ld_Spread);
            return (true);
        }
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� "�����������"                                                            |
//| �� �������� ���������� ������� (����) ����������� �������� �� �������� (�� �����  |
//| � ����� ���� �����������) ���������, ���������� ������ (�.�., ��������, ��        |
//| �������� ����� ������ +55 �. - �������� ��������� � 55/2=27 �. ���� �� ��������   |
//| ����. ����� ������ ������, ��������, +80 �., �� �������� ��������� �� ��������    |
//| (����.) ���������� ����� ���. ���������� � ������ �� �������� ���� -              |
//| 27 + (80-27)/2 = 27 + 53/2 = 27 + 26 = 53 �.                                      |
//| TrailLOSS_ON - ����� �� ������� �� �������� ������� - ���� ��, �� �� ��������     |
//| ���������� ���� ���������� ����� ���������� (� �.�. "��" ���������) � �������     |
//| ������ ����� ����������� � dCoeff ��� ����� ����. ������� �������, �����������    |
//| ������ ���� �������� �������� (�� ����� 0)                                       |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingFiftyFifty (int fi_Ticket, double& fd_NewSL)
{ 
    static datetime sdtPrevtime = 0;
//----
    //---- ���������� �������� ������ �� �������� ����
    if (sdtPrevtime == iTime (Symbol(), Trail_Period, 0)) return (0);
    sdtPrevtime = iTime (Symbol(), Trail_Period, 0);             
    //---- �������� ������� - � ������� ���� ����� ������������ (����� ��� bTrlinloss ����� �� ����� �������� 
    // ������� �������� ����� ��������� �� �������� ���������� ����� ���������� � ������ ��������)
    // �.�. �������� ������ ��� �������, ��� � ������� OrderOpenTime() ������ �� ����� Trail_Period �����      
    if (TimeCurrent() - Trail_Period * 60 > OrderOpenTime())
    {         
        double ld_NextMove;     
      
        //---- ��� ������� ������� ��������� �������� �� FF_coeff ��������� �� ����� �������� �� Bid �� ������ �������� ����
        // (���� ����� �������� ����� ���������� � �������� �������� � ������� �������)
        if (OrderType() == OP_BUY)
        {
            double dBid = Bid;
            if (bb_TrailLOSS && OrderStopLoss() != 0)
            {
                ld_NextMove = NDD (FF_coeff * (dBid - OrderStopLoss()));
                fd_NewSL = NDD (OrderStopLoss() + ld_NextMove);            
            }
            else
            {
                //---- ���� �������� ���� ����� ��������, �� ������ "�� ����� ��������"
                if (OrderOpenPrice() > OrderStopLoss())
                {
                    ld_NextMove = NDD (FF_coeff * (dBid - OrderOpenPrice()));                 
                    //Print ("Next Move = ", FF_coeff, " * (", DSDm (dBid), " - ", DSDm (OrderOpenPrice()), ") = ", DSDm (ld_NextMove));
                    fd_NewSL = NDD (OrderOpenPrice() + ld_NextMove);
                    //Print ("New SL[", DSDm (OrderStopLoss()), "] = (", DSDm (OrderOpenPrice()), " + ", DSDm (ld_NextMove), ") ", DSDm (fd_NewSL), "[", (fd_NewSL - OrderStopLoss()) / Point, "]");
                }
                //---- ���� �������� ���� ����� ��������, ������ �� ���������
                else
                {
                    ld_NextMove = NDD (FF_coeff * (dBid - OrderStopLoss()));
                    fd_NewSL = NDD (OrderStopLoss() + ld_NextMove);
                }                                       
            }
            //---- SL ���������� ������ � ������, ���� ����� �������� ����� �������� � ���� �������� - � ������� �������
            // (��� ������ ��������, �� ����� ��������, ����� �������� ����� ���� ����� ����������, � � �� �� ����� ���� 
            // ����� �������� (���� dBid ���� ����������) 
            if (ld_NextMove > 0)
            {return (true);}
        }       
        if (OrderType() == OP_SELL)
        {
            double dAsk = Ask,
                   ld_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
            if (bb_TrailLOSS && OrderStopLoss() != 0)
            {
                ld_NextMove = NDD (FF_coeff * (OrderStopLoss() - (dAsk + ld_Spread)));
                fd_NewSL = NDD (OrderStopLoss() - ld_NextMove);            
            }
            else
            {         
                //---- ���� �������� ���� ����� ��������, �� ������ "�� ����� ��������"
                if (OrderOpenPrice() < OrderStopLoss())
                {
                    ld_NextMove = NDD (FF_coeff * (OrderOpenPrice() - (dAsk + ld_Spread)));                 
                    fd_NewSL = NDD (OrderOpenPrice() - ld_NextMove);
                }
                //---- ���� �������� ���� ����� ��������, ������ �� ���������
                else
                {
                    ld_NextMove = NDD (FF_coeff * (OrderStopLoss() - (dAsk + ld_Spread)));
                    fd_NewSL = NDD (OrderStopLoss() - ld_NextMove);
                }                  
            }
            //---- SL ���������� ������ � ������, ���� ����� �������� ����� �������� � ���� �������� - � ������� �������
            if (ld_NextMove > 0)
            {return (true);}
        }               
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� KillLoss � � � � � � � � � � � � � � � � � � � �� � � �                  |
//| ����������� �� ������� ������. ����: �������� �������� ��������� ����� �� ���-    |
//| ������ �������� ����� � ����������� (SpeedCoeff). ��� ���� ����������� �����      |
//| "���������" � �������� ���������� ������ - ���, ����� ��� ������� ����������    |
//| �������� ������. ��� ������������ = 1 �������� ��������� ����� ��������� �����    |
//| ������� ��������� � ������ �� ������ ������� �������, ��� �����.>1 ����� �������  |
//| ����� � ��������� ����� ������� � ������� ��������� ��������� �����, ��������.<1 |
//| - ��������, ����� � ��������� ���������.                             �            |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool KillLoss (int fi_Ticket, double& fd_NewSL)
{
    double ld_StopPriceDiff, // ���������� (�������) ����� ������ � ����������
           ld_ToMove,        // ���-�� �������, �� ������� ������� ����������� ��������
           ld_curMove, ld_newSL, ld_Price, ld_LastPriceDiff;
    string ls_Name;
    int    li_cmd;
//----
    //---- ������� ���������� ����� ������ � ����������
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        ld_StopPriceDiff = ld_Price - OrderStopLoss();
    }
    if (OrderType() == OP_SELL)
    {
        ld_Price = Ask;
        ld_StopPriceDiff = (OrderStopLoss() + NDPm (MarketInfo (Symbol(), MODE_SPREAD))) - ld_Price;
    }
    ls_Name = StringConcatenate (fi_Ticket, "_#Delta_SL");
    //---- ���������, ���� ����� �����, ���������� ������� ���������� ����� ������ � ����������
    if (!GlobalVariableCheck (ls_Name))
    {
        GlobalVariableSet (ls_Name, ld_StopPriceDiff);
        return (false);
    }
    else
    {ld_LastPriceDiff = GlobalVariableGet (ls_Name);}
    //---- ����, � ��� ���� ����������� ��������� ��������� �����
    // �� ������ �����, ������� �������� ���� � ������� �����, 
    // �� ������ ����������� �������� ��� �� ������� �� fd_SpeedCoeff ��� �������
    // (��������, ���� ���� ���������� �� 3 ������ �� ���, fd_SpeedCoeff = 1.5, ��
    // �������� ����������� �� 3 � 1.5 = 4.5, ��������� - 5 �. ���� ��������� �� 
    // ������ (������� ������), ������ �� ������. � � � � �
        
    //---- ���-�� �������, �� ������� ����������� ���� � ��������� � ������� ���������� �������� (����, �� ����)
    ld_ToMove = (ld_LastPriceDiff - ld_StopPriceDiff) / Point;
        
    //---- ���������� ����� ��������, �� ������ ���� ��� �����������
    if (ld_StopPriceDiff + NDPm (TrailStep) < ld_LastPriceDiff)
    {GlobalVariableSet (ls_Name, ld_StopPriceDiff);}
        
    //---- ������ �������� �� ������, ���� ���������� ����������� (�.�. ���� ����������� � ���������, ������ ������)
    if (ld_ToMove >= TrailStep)
    {
        ld_ToMove = NDPm (MathRound (ld_ToMove * SpeedCoeff));
        if (OrderType() == OP_BUY) {li_cmd = 1;} else {li_cmd = -1;}
        //---- ��������, ��������������, ����� ����� ����������� �� ����� �� ����������, �� � ������ �����. ���������
        ld_curMove = li_cmd * (ld_Price - (OrderStopLoss() + li_cmd * ld_ToMove));
        fd_NewSL = OrderStopLoss() + li_cmd * ld_ToMove;
        return (true);
    }
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| �������� ����������� (��� ��������) � � � � � � � � � � � � � � � � � � � �� � �  |
//| ����������� ��� ��������, ����� �� �������� ���� � ������� ����� ��-���������.    |
//| ���� ���������� ������� Period_Average � ����������� ������� ������ ����� - ���  |
//| ����� �������� ������ (��). ��� ���������� ����� �����������, ��������� � ���-    |
//| ������. � ����� ��������� "������". ��� ���������� ����� ��������� �����,         |
//| "��������" ��� � 1.5 ����.                                                        |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailPips (int fi_Ticket, double& fd_NewSL)
{
    double ld_VirtTP, ld_TrailStop = 0.0, ld_Price;
    string ls_Name = StringConcatenate (fi_Ticket, "_#VirtTP");
    int    li_cmd;
    //---- �������� ����������� ����
    if (GlobalVariableCheck (ls_Name))
    {ld_VirtTP = GlobalVariableGet (ls_Name);}
    else
    {
        if (OrderType() == OP_BUY) {li_cmd = 1;} else {li_cmd = -1;}
        ld_VirtTP = OrderOpenPrice() + li_cmd * fGet_AverageCandle (Symbol(), Average_Period);
        GlobalVariableSet (ls_Name, ld_VirtTP);
    }
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        //---- ����������� ����������� ����
        if (ld_Price >= ld_VirtTP)
        {
            ld_VirtTP += ((ld_VirtTP - OrderOpenPrice()) / 2);
            GlobalVariableSet (ls_Name, ld_VirtTP);
        }
        //---- ������������ TrailStop - ���������� �� ������������ ����� �� ����
        for (int li_int = 4; li_int >= 2; li_int--)
        {
            if ((ld_VirtTP - OrderOpenPrice()) / li_int >= ld_VirtTP - ld_Price)
            {
                //---- ��� ����������� ����� �������� ���� �� ����, ������ ����������� ��
                if (li_int == 2)
                {ld_TrailStop = NDD ((ld_VirtTP - OrderOpenPrice()) / li_int - NDPm (ProfitMIN));}
                else
                {ld_TrailStop = NDD ((ld_VirtTP - OrderOpenPrice()) / li_int);}
                break;
            }
        }
        if (ld_TrailStop > 0)  
        {
            if (ld_Price - OrderOpenPrice() > ld_TrailStop)
            {
                fd_NewSL = NDD (ld_Price - ld_TrailStop);
                if (OrderStopLoss() + NDPm (TrailStep) < fd_NewSL || OrderStopLoss() == 0)
                {return (true);}
            }
        }
    }
    if (OrderType() == OP_SELL)
    {
        ld_Price = Ask;
        //---- ����������� ����������� ����
        if (ld_Price <= ld_VirtTP)
        {
            ld_VirtTP -= ((OrderOpenPrice() - ld_VirtTP) / 2);
            GlobalVariableSet (ls_Name, ld_VirtTP);
        }
        //---- ������������ TrailStop - ���������� �� ������������ ����� �� ����
        for (li_int = 4; li_int >= 2; li_int--)
        {
            if ((OrderOpenPrice() - ld_VirtTP) / li_int >= ld_Price - ld_VirtTP)
            {
                //---- ��� ����������� ����� �������� ���� �� ����, ������ ����������� ��
                if (li_int == 2)
                {ld_TrailStop = NDD ((OrderOpenPrice() - ld_VirtTP) / li_int - NDPm (ProfitMIN));}
                else
                {ld_TrailStop = NDD ((OrderOpenPrice() - ld_VirtTP) / li_int);}
                break;
            }
        }
        if (ld_TrailStop > 0)  
        {
            if (OrderOpenPrice() - ld_Price > ld_TrailStop)
            {
                fd_NewSL = NDD (ld_Price + ld_TrailStop);
                if (OrderStopLoss() > fd_NewSL + NDPm (TrailStep) || OrderStopLoss() == 0)
                {return (true);}
            }
        }
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//       ��������� ������� �� ����������� ������ �� ������.                           |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool fCheck_MinProfit (int fi_MinProfit, double fd_NewSL)
{
    if (!TrailLOSS_ON)
    {
        if (OrderType() == OP_BUY)
        {
            if (fd_NewSL - OrderOpenPrice() <= NDPm (fi_MinProfit))
            {return (false);}
        }
        else
        {
            if (OrderOpenPrice() - fd_NewSL <= NDPm (fi_MinProfit))
            {return (false);}
        }
    }
//----
    return (true);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        ������������ ������� �������� ������� ����� �� ���������� ������           |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
double fGet_AverageCandle (string fs_Symbol,         // ������
                           int fi_Period,            // ������
                           bool fb_IsCandle = false) // ������� �����?
{
    double ld_OPEN, ld_CLOSE, ld_HIGH, ld_LOW, ld_AVERAGE = 0;
    datetime ldt_Begin = iTime (fs_Symbol, 0, 0) - fi_Period * 60;
    int      li_cnt_Bar = iBarShift (fs_Symbol, 0, ldt_Begin);
//----
    for (int li_BAR = 1; li_BAR < li_cnt_Bar; li_BAR++)
    {
        if (fb_IsCandle)
        {
            ld_OPEN = iOpen (fs_Symbol, 0, li_BAR);
            ld_CLOSE = iClose (fs_Symbol, 0, li_BAR);
            ld_AVERAGE += MathAbs (ld_OPEN - ld_CLOSE);
        }
        else
        {
            ld_HIGH = iHigh (fs_Symbol, 0, li_BAR);
            ld_LOW = iLow (fs_Symbol, 0, li_BAR);
            ld_AVERAGE += (ld_HIGH - ld_LOW);
        }
    }
    ld_AVERAGE /= li_cnt_Bar;
    ld_AVERAGE = NormalizeDouble (ld_AVERAGE, 4);
    //Print ("Time[", li_cnt_Bar, "] = ", TimeToStr (ldt_Begin), "; ����� = ", DS0 (ld_AVERAGE / bd_Point));
//----
    return (ld_AVERAGE);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|            ��������� ����� ������� ������������ ��� GV-����������                 |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
void fClear_preGV (int fi_cntOrders = 500)
{
//---- 
    string ls_Name, lsa_Name[] = {"_#Delta_SL","_#LastLossLevel","_#VirtSL","_#VirtTP","_#BeginSL"};
    int    li_int, err = GetLastError(), li_size = ArraySize (lsa_Name);
    for (int li_ORD = fi_cntOrders; li_ORD >= 0; li_ORD--)
    {
        for (li_int = 0; li_int < li_size; li_int++)
        {
            ls_Name = StringConcatenate (li_ORD, lsa_Name[li_int]);
            if (GlobalVariableCheck (ls_Name))
            {GlobalVariableDel (ls_Name);}
        }
    }
    //fGet_LastError ("fClear_preGV()");
//---- 
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|            ��������� �������������� GV-����������                                 |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
void fClear_GV (int fi_cntOrders = 5)
{
    static int li_preTotal;
    int li_Total = OrdersHistoryTotal();
//---- 
    if (li_preTotal != li_Total)
    {
        int    li_int, li_Ticket = OrderTicket();
        string ls_Name, lsa_Name[] = {"_#Delta_SL","_#LastLossLevel","_#VirtTP"};
        if (fi_cntOrders == 0) {fi_cntOrders = li_Total;}
        for (int li_ORD = li_Total - 1; li_ORD >= MathMax (li_Total - fi_cntOrders, 0); li_ORD--)
        {
            OrderSelect (li_ORD, SELECT_BY_POS, MODE_HISTORY);
            for (li_int = 0; li_int < 2; li_int++)
            {
                ls_Name = StringConcatenate (OrderTicket(), lsa_Name[li_int]);
                if (GlobalVariableCheck (ls_Name))
                {GlobalVariableDel (ls_Name);}
            }
        }
        li_preTotal = li_Total;
        GetLastError();
        //---- �������� ������� �����
        OrderSelect (li_Ticket, SELECT_BY_TICKET, MODE_TRADES);
    }
//---- 
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|  UNI:      �������� ����� ������� �������                                         |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
int fGet_NumPeriods (int fi_Period)
{
    static int lia_Periods[] = {1,5,15,30,60,240,1440,10080,43200};
//---- 
    for (int li_PRD = 0; li_PRD < ArraySize (lia_Periods); li_PRD++)
    {if (lia_Periods[li_PRD] == fi_Period) {return (li_PRD);}}
//---- 
    return (-1);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|          The function modify order with log                                       |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool fOrder_Modify (int fi_Ticket, double fd_Price, double fd_SL, double fd_TP, datetime fdt_Expiration, color fc_color = CLR_NONE)
{
    int    li_cmd, tries = 0;
    bool   lb_result = false;				
//----
    if (!IsTradeContextBusy() && IsTradeAllowed())
    {
        if (OrderType() == OP_BUY) {li_cmd = 1;} else {li_cmd = -1;}
        double ld_SL = OrderStopLoss(), ld_TP = OrderTakeProfit();
		  while (tries < bi_NumberOfTries)
		  {
			   RefreshRates();
			   if (OrderType() == OP_BUY) {fd_Price = Bid;} else {fd_Price = Ask;}
			   lb_result = OrderModify (fi_Ticket, NDD (fd_Price), NDD (fd_SL), NDD (fd_TP), fdt_Expiration, fc_color);
			   if (!lb_result)
			   {
				    fWrite_Log (StringConcatenate ("Error Occured : ", ErrorDescription (GetLastError())));
				    fWrite_Log (StringConcatenate (Symbol(), " Price @ ", DSDm (fd_Price), " SL @ ", DSDm (fd_SL), " TP @", DSDm (fd_TP), " ticket = ", fi_Ticket));
				    tries++;
			   }
			   else
			   {
				    fWrite_Log (StringConcatenate ("modify[", bs_fName, "]: #", fi_Ticket, " ", OrderSymbol(), " Price @ ", DSDm (fd_Price), " SL[", DS0 (li_cmd * (fd_SL - ld_SL) / Point), "] = ", DSDm (fd_SL), " TP[", DS0 (li_cmd * (fd_TP - ld_TP) / Point), "] = ", DSDm (fd_TP)));
				    tries = bi_NumberOfTries;
			   }
			   Sleep (bi_RetryTime * 1000);
		  }
    }
//----
    return (lb_result);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|     ����� Log-����                                                                |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
void fWrite_Log (string fs_Txt)
{
    if (bb_VirtualTrade)
    {
        if (IsVisualMode())
	     {Print (fs_Txt);}
        return;
    }
    static datetime ldt_NewDay = 0;
    //---- ��� ��� ����� ���������� ���� ��� � �����
    if (ldt_NewDay != iTime (Symbol(), NULL, PERIOD_D1))
    {
        bs_FileName = StringConcatenate (WindowExpertName(), "_", Symbol(), "_", Period(), "-", Month(), "-", Day(), ".log");
        ldt_NewDay = iTime (Symbol(), NULL, PERIOD_D1);
    }
    int handle = FileOpen (bs_FileName, FILE_READ|FILE_WRITE|FILE_CSV, "/t");
//----
    if (StringLen (bs_fName) > 0)
    {fs_Txt = StringConcatenate (bs_fName, ": ", fs_Txt);}
    FileSeek (handle, 0, SEEK_END);      
    FileWrite (handle, StringConcatenate (" Time ", TimeToStr (TimeCurrent(), TIME_DATE|TIME_SECONDS), ": ", fs_Txt));
    FileClose (handle);
	 Print (fs_Txt);
//----
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        �������, ������������ �������� double �� Digit                             |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
double NDD (double v) {return (NormalizeDouble (v, Digits));}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        �������, �������� �������� �� double � string c ������������� �� Digit     |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
string DSDm (double v) {return (DoubleToStr (v, Digits));} 
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        �������, �������� �������� �� double � string c ������������� �� 0         |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
string DS0 (double v) {return (DoubleToStr (v, 0));} 
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        ������� "������������" �������� �� Point                                   |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
double NDPm (double v) {return (v * Point);}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+

