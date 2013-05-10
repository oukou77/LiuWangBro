//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|                                                               b-PSI@Trailing.mqh  |
//|                                                                      TarasBY&I_D  |
//|                                   Сделана на "базе" функций от I_D / Юрий Дзюбан  |
//|                                                 http://codebase.mql4.com/ru/1101  |
//|  19.10.2011  Библиотека функций трейлинга "в одном флаконе".                      |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
#property copyright "Copyright © 2011, TarasBY WM Z670270286972"
#property link      "taras_bulba@tut.by"
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|                 *****        Параметры библиотеки         *****                   |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
extern string SETUP_Trailing        = "================== TRAILING ===================";
extern int    N_Trailing               = 0;          // Вариант используемого трейлинга
extern int    Trail_Period             = PERIOD_H1;  // Период (графика), на котором производим расчёты
extern bool   TrailLOSS_ON             = FALSE;      // Включение трейлинга на LOSS`e
extern int    TrailLossAfterBar        = 12;         // После какого по счёту бара (после открытия) начинаем тралить на ЛОССе
extern int    TrailStep                = 5;          // Шаг трейлинга (минимальное приращение)
extern int    ProfitMIN                = 3;          // Минимальный профит в пп.
extern string Setup_TrailStairs     = "------------- N0 - TrailingStairs -------------";
extern int    TrailingStop            = 50;         // Скользящий тейк-профит, ноль чтобы отключить его
extern int    BreakEven                = 30;         // Уровень, на котором срабатывает БезУбыток до размера в ProfitMIN
extern string Setup_TrailByFractals = "----------- N1 - TrailingByFractals -----------";
extern int    BarsInFractal            = 0;          // Количество баров в фрактале
extern int    Indent_Fr                = 0;          // Отступ (пп.) - расстояние от макс\мин свечи, на которое переносится SL (от 0)
extern string Setup_TrailByShadows  = "----------- N2 - TrailingByShadows ------------";
extern int    BarsToShadows            = 0;          // Количество баров, по теням которых необходимо трейлинговать (от 1 и больше)
extern int    Indent_Sh                = 0;          // Отступ (пп.) - расстояние от макс\мин свечи, на которое переносится SL (от 0)
extern string Setup_TrailUdavka     = "------------- N3 - TrailingUdavka -------------";
extern int    Level_1                  = 40;         // На этом уровне трейлинг включается
extern int    Distance_1               = 70;         // До этой дистаниции размер трейлинга = Level_1
extern int    Level_2                  = 30;         // Размер трейлинга м\у Distance_1 до Distance_2
extern int    Distance_2               = 100;        // От Distance_1 до Distance_2 размер трейлинга = Level_2
extern int    Level_3                  = 20;         // После дистанции Distance_2 размер трейлинга = Level_3
extern string Setup_TrailByTime     = "------------- N4 - TrailingByTime -------------";
extern int    Interval                 = 60;         // Интервал (минут), с которым передвигается SL
extern int    TimeStep                 = 5;          // Шаг трейлинга (на сколько пунктов) перемещается SL
extern string Setup_TrailByATR      = "------------- N5 - TrailingByATR --------------";
extern int    ATR_Period1              = 9;          // период первого ATR (больше 0; может быть равен ATR_Period2, но лучше отличен от последнего)
extern int    ATR_shift1               = 2;          // для первого ATR сдвиг "окна" (неотрицательное целое число)
extern int    ATR_Period2              = 14;         // период второго ATR (больше 0)
extern int    ATR_shift2               = 3;          // для второго ATR сдвиг "окна", (неотрицательное целое число)
extern double ATR_coeff                = 2.5;        // 
extern string Setup_TrailRatchetB   = "------------ N6 - TrailingRatchetB ------------";
extern int    ProfitLevel_1            = 20;
extern int    ProfitLevel_2            = 30;
extern int    ProfitLevel_3            = 50;
extern int    StopLevel_1              = 2;
extern int    StopLevel_2              = 5;
extern int    StopLevel_3              = 15;
extern string Setup_TrailByPriceCh  = "--------- N7 - TrailingByPriceChannel ---------";
extern int    BarsInChannel            = 10;        // период (кол-во баров) для рассчета верхней и нижней границ канала
extern int    Indent_Pr                = 15;        // отступ (пунктов), на котором размещается стоплосс от границы канала
extern string Setup_TrailByMA       = "-------------- N8 - TrailingByMA --------------";
extern int    MA_Period                = 14;        // 2-infinity, целые числа
extern int    MA_Shift                 = 0;         // целые положительные или отрицательные числа, а также 0
extern int    MA_Method                = 1;         // 0 (MODE_SMA), 1 (MODE_EMA), 2 (MODE_SMMA), 3 (MODE_LWMA)
extern int    MA_Price                 = 0;         // 0 (PRICE_CLOSE), 1 (PRICE_OPEN), 2 (PRICE_HIGH), 3 (PRICE_LOW), 4 (PRICE_MEDIAN), 5 (PRICE_TYPICAL), 6 (PRICE_WEIGHTED)
extern int    MA_Bar                   = 0;         // 0-Bars, целые числа
extern int    Indent_MA                = 10;        // 0-infinity, целые числа
extern string Setup_TrailFiftyFifty = "----------- N9 - TrailingFiftyFifty -----------";
extern double FF_coeff                 = 0.05;      // "коэффициент поджатия", в % от 0.01 до 1 (в последнем случае SL будет перенесен (если получится) вплотную к тек. курсу и позиция, скорее всего, сразу же закроется)
extern string Setup_TrailKillLoss   = "----------- N10 - TrailingKillLoss ------------";
extern double SpeedCoeff               = 0.5;       // "скорость" движения курса
extern string Setup_TrailPips       = "--------------- N11 - TrailPips ---------------";
extern int    Average_Period           = PERIOD_D1; // На каком периоде вычисляем среднюю свечу
//IIIIIIIIIIIIIIIIIII=========Подключение внешних модулей=======IIIIIIIIIIIIIIIIIIIIII+
#include <stdlib.mqh>                               // Библиотека расшифровки ошибок
//IIIIIIIIIIIIIIIIIII========Глобальные переменные модуля========IIIIIIIIIIIIIIIIIIIII+
double gd_TrailStop, gd_TrailStep, bda_ProfitLevel[3], bd_ProfitMIN;
bool   bb_VirtualTrade = false, bb_TrailLOSS;
string bs_fName, bs_FileName;
int    bi_NumberOfTries = 10,      // Количестов попыток по модификации ордера
       bi_RetryTime = 500,         // Столько миллисекунд пауза м\у торговыми попытками
       bia_StopLevel[3];
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//       Трейлингуем конкретную позицию.                                              |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
void fTrail_Position (int fi_Ticket)
{
    static bool lb_first = true;
    double ld_NewSL = 0.0, ld_Price;
    bool   lb_Trail = false;
//----
    //---- При первом запуске формируем значения рабочих переменных
    // и проверяем корректность передаваемых в функцию параметров
    if (lb_first)
    {
        if (!fCheck_TrailParameters())
        {
            Alert ("Проверьте параметры выбранного Вами Трейлинга !!!");
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
    //---- Обрабатываем выбранный номер трейлинга
    switch (N_Trailing)
    {
        case 1: // ТРЕЙЛИНГ ПО ФРАКТАЛАМ
            bs_fName = "TrailingByFractals()";
            lb_Trail = TrailingByFractals (fi_Ticket, ld_NewSL);
            break;
        case 2: // ТРЕЙЛИНГ ПО ТЕНЯМ N СВЕЧЕЙ
            bs_fName = "TrailingByShadows()";
            lb_Trail = TrailingByShadows (fi_Ticket, ld_NewSL);
            break;
        case 3: // ТРЕЙЛИНГ СТАНДАРТНЫЙ-"УДАВКА"
            bs_fName = "TrailingUdavka()";
            lb_Trail = TrailingUdavka (fi_Ticket, ld_NewSL);
            break;
        case 4: // ТРЕЙЛИНГ ПО ВРЕМЕНИ
            bs_fName = "TrailingByTime()";
            lb_Trail = TrailingByTime (fi_Ticket, ld_NewSL);
            break;
        case 5: // ТРЕЙЛИНГ ПО ATR
            bs_fName = "TrailingByATR()";
            lb_Trail = TrailingByATR (fi_Ticket, ld_NewSL);
            break;
        case 6: // ТРЕЙЛИНГ RATCHET БАРИШПОЛЬЦА
            bs_fName = "TrailingRatchetB()";
            lb_Trail = TrailingRatchetB (fi_Ticket, ld_NewSL);
            break;
        case 7: // ТРЕЙЛИНГ ПО ЦЕНВОМУ КАНАЛУ
            bs_fName = "TrailingByPriceChannel()";
            lb_Trail = TrailingByPriceChannel (fi_Ticket, ld_NewSL);
            break;
        case 8: // ТРЕЙЛИНГ ПО СКОЛЬЗЯЩЕМУ СРЕДНЕМУ
            bs_fName = "TrailingByMA()";
            lb_Trail = TrailingByMA (fi_Ticket, ld_NewSL);
            break;
        case 9: // ТРЕЙЛИНГ "ПОЛОВИНЯЩИЙ"
            bs_fName = "TrailingFiftyFifty()";
            lb_Trail = TrailingFiftyFifty (fi_Ticket, ld_NewSL);
            break;
        case 10: // ТРЕЙЛИНГ KillLoss
            bs_fName = "KillLoss()";
            lb_Trail = KillLoss (fi_Ticket, ld_NewSL);
            break;
        case 11: // ТРЕЙЛИНГ "ПИПСОВОЧНЫЙ"
            bs_fName = "TrailPips()";
            lb_Trail = TrailPips (fi_Ticket, ld_NewSL);
            break;
        default: // СТАНДАРТНЫЙ-СТУПЕНЧАСТЫЙ
            bs_fName = "TrailingStairs()";
            lb_Trail = TrailingStairs (fi_Ticket, ld_NewSL);
            break;
    }
    //---- Модифицируем стоплосс
    if (lb_Trail)
    {
        //---- Подчищаем за собой GV-переменные
        fClear_GV();
        double ld_MinSTOP = NDPm (MarketInfo (Symbol(), MODE_STOPLEVEL));
        //---- Нормализуем новый SL по минимально заданному
        if (OrderType() == OP_BUY) {ld_NewSL = MathMin (ld_NewSL, Bid - ld_MinSTOP);}
        else {ld_NewSL = MathMax (ld_NewSL, Ask + ld_MinSTOP);}
        double ld_SL = NormalizeDouble (OrderStopLoss(), 4);
        ld_NewSL = NormalizeDouble (ld_NewSL, 4);
        //---- SL тянем в сторону уменьшения убытка
        if ((((ld_NewSL > ld_SL && OrderType() == OP_BUY)
        || (ld_NewSL < ld_SL && OrderType() == OP_SELL)) || OrderStopLoss() == 0)
        && fCheck_MinProfit (ProfitMIN, ld_NewSL))
        {fOrder_Modify (fi_Ticket, ld_Price, ld_NewSL, OrderTakeProfit(), 0, Gold);}
    }
//----
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//       Проверяем переданные в функцию внешние параметры.                            |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool fCheck_TrailParameters()
{
    int li_Decimal = 1;
//----
    if (Trail_Period == 0) {Trail_Period = Period();}
    //---- По умолчанию тралить ЛОСС начинаем спустя сутки
    if (TrailLossAfterBar == 0)
    {TrailLossAfterBar = PERIOD_D1 / Period();}
    //---- Флаг разрешения написания лога в файл
    if (IsOptimization() || IsTesting())
    {
        bb_VirtualTrade = true;
        //---- Подчищаем возможно оставшиеся GV-переменные
        fClear_preGV();
    }
    //---- Формируем имя файла для лога
    bs_FileName = StringConcatenate (WindowExpertName(), "_", Symbol(), "_", Period(), "-", Month(), "-", Day(), ".log");
    //---- Производим проверки корректности заданных пользователем параметров
    if (fGet_NumPeriods (Trail_Period) < 0)
    {
        Alert ("Не правильно задан ПЕРИОД (переменная Trail_Period) !!!");
        return (false);
    }
    if (TrailLOSS_ON && TrailLossAfterBar < 0)
    {
        Print ("Поставьте TrailLossAfterBar >= 0 !!!");
        return (false);
    }
    if (TrailStep < 1 && (N_Trailing == 0 || N_Trailing == 10 || N_Trailing == 11))
    {
        Print ("Поставьте TrailStep >= 1 !!!");
        return (false);
    }
    if ((TrailingStop < TrailStep || TrailingStop < BreakEven || BreakEven < 0) && N_Trailing == 0)
    {
        Print ("Трейлинг функцией TrailingStairs() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((BarsInFractal <= 3 || Indent_Fr < 0) && N_Trailing == 1)
    {
        Print ("Трейлинг функцией TrailingByFractals() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((BarsToShadows < 1 || Indent_Sh < 0) && N_Trailing == 2)
    {
        Print ("Трейлинг функцией TrailingByShadows() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((Level_1 >= Distance_1 || Level_2 >= Level_1 || Level_3 >= Level_2 || Distance_1 >= Distance_2) && N_Trailing == 3)
    {
        Print ("Трейлинг функцией TrailingUdavka() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((Interval < 1 || TimeStep < 1) && N_Trailing == 4)
    {
        Print ("Трейлинг функцией TrailingByTime() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((ATR_Period1 < 1 || ATR_Period2 < 1 || ATR_coeff <= 0) && N_Trailing == 5)
    {
        Print ("Трейлинг функцией TrailingByATR() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((ProfitLevel_2 <= ProfitLevel_1 || ProfitLevel_3 <= ProfitLevel_2 || ProfitLevel_3 <= ProfitLevel_1) && N_Trailing == 6)
    {
        Print ("Трейлинг функцией TrailingRatchetB() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((BarsInChannel < 1 || Indent_Pr < 0) && N_Trailing == 7)
    {
        Print ("Трейлинг функцией TrailingByPriceChannel() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((MA_Period < 2 || MA_Method < 0 || MA_Method > 3 || MA_Price < 0 || MA_Price > 6 || MA_Bar < 0 || Indent_MA < 0) && N_Trailing == 8)
    {
        Print ("Трейлинг функцией TrailingByMA() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if ((FF_coeff < 0.01 || FF_coeff > 1.0) && N_Trailing == 9)
    {
        Print ("Трейлинг функцией TrailingFiftyFifty() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    if (SpeedCoeff < 0.1 && N_Trailing == 10)
    {
        Print ("Трейлинг функцией KillLoss() невозможен из-за некорректности значений переданных ей аргументов.");
        return (0);
    }
    if (Average_Period <= Period() && N_Trailing == 11)
    {
        Print ("Трейлинг функцией TrailPips() невозможен из-за некорректности значений переданных ей аргументов.");
        return (false);
    }
    //---- Приводим внешние переменные в соответствии с разрядностью котировок ДЦ
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
//| ТРЕЙЛИНГ ПО ФРАКТАЛАМ                                                             |
//| Функции передаётся тикет позиции, количество баров в фрактале, и отступ (пунктов) |
//| - расстояние от макс. (мин.) свечи, на которое переносится стоплосс (от 0),       |
//|  trlinloss - тралить ли в зоне убытков                                            |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByFractals (int fi_Ticket, double& fd_NewSL)
{
    int    i, z,             // counters
           li_ExtremN,       // номер ближайшего экстремума frktl_bars-барного фрактала 
           after_x, be4_x,   // свечей после и до пика соответственно
           ok_be4, ok_after, // флаги соответствия условию (1 - неправильно, 0 - правильно)
           lia_PeakN[2];     // номера экстремумов ближайших фракталов на продажу/покупку соответственно   
    double ld_Indent = NDPm (Indent_Fr),
           ld_tmp;           // служебная переменная
//----
    ld_tmp = BarsInFractal;
    if (MathMod (BarsInFractal, 2) == 0) {li_ExtremN = ld_tmp / 2;}
    else {li_ExtremN = MathRound (ld_tmp / 2);}
    //---- Баров до и после экстремума фрактала
    after_x = BarsInFractal - li_ExtremN;
    if (MathMod (BarsInFractal, 2) != 0) {be4_x = BarsInFractal - li_ExtremN;}
    else {be4_x = BarsInFractal - li_ExtremN - 1;}
    //---- Если OP_BUY, находим ближайший фрактал на продажу (т.е. экстремум "вниз")
    if (OrderType() == OP_BUY)
    {
        //---- Находим последний фрактал на продажу
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
        //---- Проверяем условие на трал покупки
        double ld_Peak = iLow (Symbol(), Trail_Period, lia_PeakN[1]);
        //---- Если новый стоплосс лучше имеющегося (в т.ч. если стоплосс == 0, не выставлен)
        if ((ld_Peak - ld_Indent > OrderStopLoss())
        && (bb_TrailLOSS || (!TrailLOSS_ON && ld_Peak - ld_Indent > OrderOpenPrice())))
        {
            fd_NewSL = ld_Peak - ld_Indent;
            return (true);
        }
    }
    //---- Если OP_SELL, находим ближайший фрактал на покупку (т.е. экстремум "вверх")
    if (OrderType() == OP_SELL)
    {
        //---- Находим последний фрактал на покупку
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
        //---- Если новый стоплосс лучше имеющегося (в т.ч. если стоплосс == 0, не выставлен)
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
//| ТРЕЙЛИНГ ПО ТЕНЯМ N СВЕЧЕЙ                                                        |
//| Функции использует количество баров, по теням которых необходимо трейлинговать    |
//| (от 1 и больше) и отступ (пунктов) - расстояние от макс. (мин.) свечи, на         |
//| которое переносится стоплосс (от 0), TrailLOSS_ON - тралить ли в лоссе            |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByShadows (int fi_Ticket, double& fd_NewSL)
{
    double ld_Extremum, ld_Indent = NDPm (Indent_Sh);
//----
    //---- Если длинная позиция (OP_BUY), находим минимум BarsToShadows свечей
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
    //---- Если OP_SELL, находим максимум BarsToShadows свечей
    if (OrderType() == OP_SELL)
    {
        ld_Extremum = iHigh (Symbol(), Trail_Period, iHighest (Symbol(), Trail_Period, MODE_HIGH, BarsToShadows, 1));
        ld_Indent += NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        //---- Если новый стоплосс лучше имеющегося (в т.ч. если стоплосс == 0, не выставлен)
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
//| ТРЕЙЛИНГ СТАНДАРТНЫЙ-СТУПЕНЧАСТЫЙ                                                 |
//| Функции передаётся тикет позиции, расстояние от курса открытия, на котором        |
//| трейлинг запускается (пунктов) и "шаг", с которым он переносится (пунктов)        |
//| Пример: при +30 стоп на +10, при +40 - стоп на +20 и т.д.                         |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingStairs (int fi_Ticket, double& fd_NewSL)
{
    double ld_Price;
//----
    gd_TrailStop = NDPm (TrailingStop);
    gd_TrailStep = NDPm (TrailStep);
    //---- Если длинная позиция (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        //---- Прописываем работу БУ для покупки
        if (BreakEven > 0)
        {
            if ((ld_Price - OrderOpenPrice()) > NDPm (BreakEven))
            {
                //---- Модификация стопов в БУ выполняется один раз
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
    //---- Если короткая позиция (OP_SELL)
    if (OrderType() == OP_SELL)
    { 
        ld_Price = Ask;
        double ld_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        gd_TrailStop += ld_Spread;
        //---- Прописываем работу БУ для продажи
        if (BreakEven > 0)
        {
            if ((OrderOpenPrice() - ld_Price) > NDPm (BreakEven) + ld_Spread)
            {
                //---- Модификация стопов в БУ выполняется один раз
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
//| ТРЕЙЛИНГ СТАНДАРТНЫЙ-"УДАВКА"                                                     |
//| Пример: исходный трейлинг 30 п., при +50 - 20 п., +80 >= - на расстоянии в 10 п.  |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingUdavka (int fi_Ticket, double& fd_NewSL)
{
    double ld_Price, ld_MovePrice;
//----
    gd_TrailStep = NDPm (TrailStep);
    gd_TrailStop = 0.0;
    //---- Если длинная позиция (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        ld_MovePrice = ld_Price - OrderOpenPrice();
        if (ld_MovePrice <= 0)
        {return (false);}
        //---- Определяем расстояние от СТОПа до цены (плавающий размер трейлинга)
        if (ld_MovePrice <= NDPm (Distance_1)) {gd_TrailStop = Level_1;}
        if (ld_MovePrice > NDPm (Distance_1) && ld_MovePrice <= NDPm (Distance_2))
        {gd_TrailStop = Level_2;}
        if (ld_MovePrice > NDPm (Distance_2)) {gd_TrailStop = Level_3;}
        gd_TrailStop *= Point;
        //---- Если стоплосс = 0 или меньше курса открытия, то если тек.цена (Bid) больше/равна дистанции курс_открытия + расст.трейлинга
        if (OrderStopLoss() < OrderOpenPrice())
        {
            if (ld_MovePrice > gd_TrailStop + gd_TrailStep)
            {
                fd_NewSL = ld_Price - gd_TrailStop;
                return (true);
            }
        }
        //---- Иначе: если текущая цена (Bid) больше/равна дистанции текущий_стоплосс + расстояние трейлинга, 
        else
        {
            if (ld_Price - OrderStopLoss() > gd_TrailStop + gd_TrailStep)
            {
                fd_NewSL = ld_Price - gd_TrailStop;
                return (true);
            }
        }
    }
    //---- Если короткая позиция (OP_SELL)
    if (OrderType() == OP_SELL)
    { 
        double gd_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        ld_Price = Ask;
        ld_MovePrice = OrderOpenPrice() - (ld_Price + gd_Spread);
        if (ld_MovePrice <= 0)
        {return (false);}
        //---- Определяем расстояние от СТОПа до цены (плавающий размер трейлинга)
        if (ld_MovePrice <= NDPm (Distance_1)) {gd_TrailStop = Level_1;}
        if (ld_MovePrice > NDPm (Distance_1) && ld_MovePrice <= NDPm (Distance_2))
        {gd_TrailStop = Level_2;}
        if (ld_MovePrice > NDPm (Distance_2)) {gd_TrailStop = Level_3;}
        gd_TrailStop *= Point;
        // если стоплосс = 0 или меньше курса открытия, то если тек.цена (Ask) больше/равна дистанции курс_открытия+расст.трейлинга
        if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice())
        {
            if (ld_MovePrice > gd_TrailStop + gd_TrailStep)
            {
                fd_NewSL = ld_Price + gd_TrailStop;
                return (true);
            }
        }
        //---- Иначе: если текущая цена (Bid) больше/равна дистанции текущий_стоплосс + расстояние трейлинга, 
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
//| ТРЕЙЛИНГ ПО ВРЕМЕНИ                                                               |
//| Функции передаётся тикет позиции, интервал (минут), с которым, передвигается      |
//| стоплосс и шаг трейлинга (на сколько пунктов перемещается стоплосс, TrailLOSS_ON  |
//| - тралим ли в убытке (т.е. с определённым интервалом подтягиваем стоп до курса    |
//| открытия, а потом и в профите, либо только в профите)                             |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByTime (int fi_Ticket, double& fd_NewSL)
{
    int    li_MinPast;    // кол-во полных минут от открытия позиции до текущего момента 
    double times2change;  // кол-во интервалов Interval с момента открытия позиции (т.е. сколько раз должен был быть перемещен стоплосс) 
//----
    //---- Определяем, сколько времени прошло с момента открытия позиции
    li_MinPast = (TimeCurrent() - OrderOpenTime()) / 60;
    //---- Сколько раз нужно было передвинуть стоплосс
    times2change = MathFloor (li_MinPast / Interval);
    //---- Если длинная позиция (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        //---- Если тралим в убытке, то отступаем от стоплосса (если он не 0, если 0 - от открытия)
        if (bb_TrailLOSS)
        {
            if (OrderStopLoss() == 0) {fd_NewSL = OrderOpenPrice() + times2change * NDPm (TimeStep);}
            else {fd_NewSL = OrderStopLoss() + times2change * NDPm (TimeStep);}
        }
        //---- Иначе - от курса открытия позиции
        else
        {fd_NewSL = OrderOpenPrice() + times2change * NDPm (TimeStep);}
    }
    //---- Если короткая позиция (OP_SELL)
    if (OrderType() == OP_SELL)
    {
        double gd_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
        //---- Если тралим в убытке, то отступаем от стоплосса (если он не 0, если 0 - от открытия)
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
//| ТРЕЙЛИНГ ПО ATR (Average True Range, Средний истинный диапазон)                   |
//| Функции передаётся тикет позиции, период АТR и коэффициент, на который умножается |
//| ATR. Т.о. стоплосс "тянется" на расстоянии ATR х N от текущего курса;             |
//| перенос - на новом баре (т.е. от цены открытия очередного бара)                   |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByATR (int fi_Ticket, double& fd_NewSL)
{
    double ld_ATR, ld_Price,
           ld_Coeff; // результат умножения большего из ATR на коэффициент
//----
    //---- Текущее значение ATR
    ld_ATR = iATR (Symbol(), Trail_Period, ATR_Period1, ATR_shift1);
    ld_ATR = MathMax (ld_ATR, iATR (Symbol(), Trail_Period, ATR_Period2, ATR_shift2));
    //---- После умножения на коэффициент
    ld_Coeff = ld_ATR * ATR_coeff;
    //---- Если длинная позиция (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        ld_Price = Bid;
        //---- Откладываем от текущего курса (новый стоплосс)
        fd_NewSL = ld_Price - ld_Coeff;
        //---- Если TrailLOSS_ON == true (т.е. следует тралить в зоне лоссов), то
        if ((bb_TrailLOSS && fd_NewSL > OrderStopLoss())
        //---- Иначе тралим от курса открытия
        || (!TrailLOSS_ON && fd_NewSL > OrderOpenPrice()))
        {return (true);}
    }
    //---- Если короткая позиция (OP_SELL)
    if (OrderType() == OP_SELL)
    {
        ld_Price = Ask;
        //---- Откладываем от текущего курса (новый стоплосс)
        fd_NewSL = ld_Price + (ld_Coeff + NDPm (MarketInfo (Symbol(), MODE_SPREAD)));
        //---- Если TrailLOSS_ON == true (т.е. следует тралить в зоне лоссов), то
        if ((bb_TrailLOSS && (fd_NewSL < OrderStopLoss() || OrderStopLoss() == 0))
        //---- Иначе тралим от курса открытия
        || (!TrailLOSS_ON && fd_NewSL < OrderOpenPrice()))
        {return (true);}
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| ТРЕЙЛИНГ RATCHET БАРИШПОЛЬЦА                                                      |
//| При достижении профитом уровня 1 стоплосс - в +1, при достижении профитом уровня  |
//| 2 профита - стоплосс - на уровень 1, когда профит достигает уровня 3 профита,     |
//| стоплосс - на уровень 2 (дальше можно трейлить другими методами)                  |
//| при работе в лоссовом участке - тоже 3 уровня, но схема работы с ними несколько   |
//| иная,  а именно: если мы опустились ниже уровня, а потом поднялись выше него      |
//| (пример для покупки), то стоплосс ставим на следующий, более глубокий уровень     |
//| (например, уровни -5, -10 и -25, стоплосс -40; если опустились ниже -10, а потом  |
//| поднялись выше -10, то стоплосс - на -25, если поднимемся выще -5, то стоплосс    |
//| перенесем на -10, при -2 (спрэд) стоп на -5                                       |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingRatchetB (int fi_Ticket, double& fd_NewSL)
{
    bool lb_result = false;
    double ld_Spread = NDPm (MarketInfo (Symbol(), MODE_SPREAD));
//----
    //---- Если длинная позиция (OP_BUY)
    if (OrderType() == OP_BUY)
    {
        double dBid = Bid, ld_ProfitLevel;
        //---- Работаем на участке профитов
        for (int li_IND = 2; li_IND >= 0; li_IND--)
        {
            //---- Если разница "текущий_курс-курс_открытия" > "ProfitLevel_N+спрэд", SL переносим в "ProfitLevel_N-1+спрэд"
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
        //---- Работаем на участке лоссов
        if (bb_TrailLOSS)      
        {
            //---- Подчищаем за собой отработанные глобальные переменные
            double ld_LastLossLevel;
            string ls_Name = StringConcatenate (fi_Ticket, "_#LastLossLevel");
            //---- Глобальная переменная терминала содержит значение самого уровня убытка (StopLevel_n), ниже которого опускался курс
            // (если он после этого поднимается выше, устанавливаем SL на ближайшем более глубоком уровне убытка (если это не начальный SL позиции)
            if (!GlobalVariableCheck (ls_Name))
            {GlobalVariableSet (ls_Name, 0);}
            else
            {ld_LastLossLevel = GlobalVariableGet (ls_Name);}
            //---- Убыточным считаем участок ниже курса открытия и до первого уровня профита
            if (dBid - OrderOpenPrice() < NDPm (ProfitLevel_1))
            {
                //---- Если (текущий_курс лучше/равно открытие) и (dpstlslvl>=StopLevel_1), стоплосс - на StopLevel_1
                if (dBid >= OrderOpenPrice())
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice() - NDPm (StopLevel_1))
                    {
                        fd_NewSL = OrderOpenPrice() - NDPm (StopLevel_1);
                        lb_result = true;
                    }
                }
                //---- Если (текущий_курс лучше уровня_убытка_1) и (dpstlslvl>=StopLevel_1), стоплосс - на StopLevel_2
                if (dBid >= OrderOpenPrice() - NDPm (StopLevel_1) && ld_LastLossLevel >= StopLevel_1)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice() - NDPm (StopLevel_2))
                    {
                        fd_NewSL = OrderOpenPrice() - NDPm (StopLevel_2);
                        lb_result = true;
                    }
                }
                //---- Если (текущий_курс лучше уровня_убытка_2) и (dpstlslvl>=StopLevel_2), стоплосс - на StopLevel_3
                if (dBid >= OrderOpenPrice() - NDPm (StopLevel_2) && ld_LastLossLevel >= StopLevel_2)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() < OrderOpenPrice() - NDPm (StopLevel_3))
                    {
                        fd_NewSL = OrderOpenPrice() - NDPm (StopLevel_3);
                        lb_result = true;
                    }
                }
                //---- Проверим/обновим значение наиболее глубокой "взятой" лоссовой "ступеньки"
                //---- Если "текущий_курс-курс открытия + спрэд" меньше 0, 
                if (dBid - OrderOpenPrice() + ld_Spread < 0)
                //---- Проверим, не меньше ли он того или иного уровня убытка
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
    //---- Если короткая позиция (OP_SELL)
    if (OrderType() == OP_SELL)
    {
        double dAsk = Ask;
        //---- Работаем на участке профитов
        //---- Если разница "текущий_курс-курс_открытия" > "ProfitLevel_3+спрэд", SL переносим в "ProfitLevel_2+спрэд"
        for (li_IND = 2; li_IND >= 0; li_IND--)
        {
            //---- Если разница "текущий_курс-курс_открытия" > "ProfitLevel_N+спрэд", SL переносим в "ProfitLevel_N-1+спрэд"
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
        //---- Работаем на участке лоссов
        if (bb_TrailLOSS)      
        {
            //---- Подчищаем за собой отработанные глобальные переменные
            ls_Name = StringConcatenate (fi_Ticket, "_#LastLossLevel");
            //---- Глобальная переменная терминала содержит значение самого уровня убытка (StopLevel_n), ниже которого опускался курс
            // (если он после этого поднимается выше, устанавливаем SL на ближайшем более глубоком уровне убытка (если это не начальный SL позиции)
            if (!GlobalVariableCheck (ls_Name))
            {GlobalVariableSet (ls_Name, 0);}
            else
            {ld_LastLossLevel = GlobalVariableGet (ls_Name);}
            //---- Убыточным считаем участок ниже курса открытия и до первого уровня профита
            if (OrderOpenPrice() - dAsk < NDPm (ProfitLevel_1))         
            {
                //---- Если (текущий_курс лучше/равно открытие) и (dpstlslvl>=StopLevel_1), SL - на StopLevel_1
                if (dAsk <= OrderOpenPrice())
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice() + (NDPm (StopLevel_1) + ld_Spread))
                    {
                        fd_NewSL = OrderOpenPrice() + (NDPm (StopLevel_1) + ld_Spread);
                        lb_result = true;
                    }
                }
                //---- Если (текущий_курс лучше уровня_убытка_1) и (dpstlslvl>=StopLevel_1), SL - на StopLevel_2
                if (dAsk <= OrderOpenPrice() + (NDPm (StopLevel_1) + ld_Spread) && ld_LastLossLevel >= StopLevel_1)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice() + (NDPm (StopLevel_2) + ld_Spread))
                    {
                        fd_NewSL = OrderOpenPrice() + (NDPm (StopLevel_2) + ld_Spread);
                        lb_result = true;
                    }
                }
                //---- Если (текущий_курс лучше уровня_убытка_2) и (dpstlslvl>=StopLevel_2), SL - на StopLevel_3
                if (dAsk <= OrderOpenPrice() + (NDPm (StopLevel_2) + ld_Spread) && ld_LastLossLevel >= StopLevel_2)
                {
                    if (OrderStopLoss() == 0 || OrderStopLoss() > OrderOpenPrice() + (NDPm (StopLevel_3) + ld_Spread))
                    {
                        fd_NewSL = OrderOpenPrice() + (NDPm (StopLevel_3) + ld_Spread);
                        lb_result = true;
                    }
                }
                //---- Проверим/обновим значение наиболее глубокой "взятой" лоссовой "ступеньки"
                //---- Если "текущий_курс-курс открытия+спрэд" меньше 0, 
                if (OrderOpenPrice() - dAsk + ld_Spread < 0)
                //---- Проверим, не меньше ли он того или иного уровня убытка
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
//| ТРЕЙЛИНГ ПО ЦЕНВОМУ КАНАЛУ                                                        |
//| Добавлен по совету Nickolay Zhilin (aka rebus) Трейлинг по закрывшимся барам.     |
//| Функции передаётся тикет позиции, период (кол-во баров) для рассчета верхней и    | 
//| нижней границ канала, отступ (пунктов), на котором размещается стоплосс от        |
//| границы канала                                                                    |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByPriceChannel (int fi_Ticket, double& fd_NewSL)
{     
    double ld_ChnlMax, // верхняя граница канала
           ld_ChnlMin; // нижняя граница канала
//----
    //---- Определяем макс.хай и мин.лоу за BarsInChannel баров начиная с [1] (= верхняя и нижняя границы ценового канала)
    ld_ChnlMax = iHigh (Symbol(), Trail_Period, iHighest (Symbol(), Trail_Period, MODE_HIGH, BarsInChannel, 1)) + NDPm ((Indent_Pr + MarketInfo (Symbol(), MODE_SPREAD)));
    ld_ChnlMin = iLow (Symbol(), Trail_Period, iLowest (Symbol(), Trail_Period, MODE_LOW, BarsInChannel, 1)) - NDPm (Indent_Pr);   
   
    //---- Если длинная позиция, и её стоплосс хуже (ниже нижней границы канала либо не определен, == 0), модифицируем его
    if (OrderType() == OP_BUY)
    {
        if (OrderStopLoss() < ld_ChnlMin)
        {
            fd_NewSL = ld_ChnlMin;
            return (true);
        }
    }
    //---- Если позиция - короткая, и её стоплосс хуже (выше верхней границы канала или не определён, == 0), модифицируем его
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
//| ТРЕЙЛИНГ ПО СКОЛЬЗЯЩЕМУ СРЕДНЕМУ                                 |
//| Функции передаётся тикет позиции и параметры средней (таймфрейм, | 
//| период, тип, сдвиг относительно графика, метод сглаживания,      |
//| составляющая OHCL для построения, № бара, на котором берется     |
//| значение средней.                                                |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingByMA (int fi_Ticket, double& fd_NewSL)
{     
    double ld_MA; // значение скользящего среднего с переданными параметрами
   
    //---- Определим значение МА с переданными функции параметрами
    ld_MA = iMA (Symbol(), Trail_Period, MA_Period, MA_Shift, MA_Method, MA_Price, MA_Bar);
    //---- Если длинная позиция, и её стоплосс хуже значения среднего с отступом в Indent_MA пунктов, модифицируем его
    if (OrderType() == OP_BUY)
    {
        if (OrderStopLoss() < ld_MA - NDPm (Indent_MA))
        {
            fd_NewSL = ld_MA - NDPm (Indent_MA);
            return (true);
        }
    }
    //---- Если позиция - короткая, и её стоплосс хуже (выше верхней границы канала или не определён, ==0), модифицируем его
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
//| ТРЕЙЛИНГ "ПОЛОВИНЯЩИЙ"                                                            |
//| По закрытии очередного периода (бара) подтягиваем стоплосс на половину (но можно  |
//| и любой иной коэффициент) дистанции, пройденной курсом (т.е., например, по        |
//| закрытии суток профит +55 п. - стоплосс переносим в 55/2=27 п. Если по закрытии   |
//| след. суток профит достиг, допустим, +80 п., то стоплосс переносим на половину    |
//| (напр.) расстояния между тек. стоплоссом и курсом на закрытии бара -              |
//| 27 + (80-27)/2 = 27 + 53/2 = 27 + 26 = 53 п.                                      |
//| TrailLOSS_ON - стоит ли тралить на лоссовом участке - если да, то по закрытию     |
//| очередного бара расстояние между стоплоссом (в т.ч. "до" безубытка) и текущим     |
//| курсом будет сокращаться в dCoeff раз чтобы посл. вариант работал, обязательно    |
//| должен быть определён стоплосс (не равен 0)                                       |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailingFiftyFifty (int fi_Ticket, double& fd_NewSL)
{ 
    static datetime sdtPrevtime = 0;
//----
    //---- Активируем трейлинг только по закрытии бара
    if (sdtPrevtime == iTime (Symbol(), Trail_Period, 0)) return (0);
    sdtPrevtime = iTime (Symbol(), Trail_Period, 0);             
    //---- Начинаем тралить - с первого бара после открывающего (иначе при bTrlinloss сразу же после открытия 
    // позиции стоплосс будет перенесен на половину расстояния между стоплоссом и курсом открытия)
    // т.е. работаем только при условии, что с момента OrderOpenTime() прошло не менее Trail_Period минут      
    if (TimeCurrent() - Trail_Period * 60 > OrderOpenTime())
    {         
        double ld_NextMove;     
      
        //---- Для длинной позиции переносим стоплосс на FF_coeff дистанции от курса открытия до Bid на момент открытия бара
        // (если такой стоплосс лучше имеющегося и изменяет стоплосс в сторону профита)
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
                //---- Если стоплосс ниже курса открытия, то тралим "от курса открытия"
                if (OrderOpenPrice() > OrderStopLoss())
                {
                    ld_NextMove = NDD (FF_coeff * (dBid - OrderOpenPrice()));                 
                    //Print ("Next Move = ", FF_coeff, " * (", DSDm (dBid), " - ", DSDm (OrderOpenPrice()), ") = ", DSDm (ld_NextMove));
                    fd_NewSL = NDD (OrderOpenPrice() + ld_NextMove);
                    //Print ("New SL[", DSDm (OrderStopLoss()), "] = (", DSDm (OrderOpenPrice()), " + ", DSDm (ld_NextMove), ") ", DSDm (fd_NewSL), "[", (fd_NewSL - OrderStopLoss()) / Point, "]");
                }
                //---- Если стоплосс выше курса открытия, тралим от стоплосса
                else
                {
                    ld_NextMove = NDD (FF_coeff * (dBid - OrderStopLoss()));
                    fd_NewSL = NDD (OrderStopLoss() + ld_NextMove);
                }                                       
            }
            //---- SL перемещаем только в случае, если новый стоплосс лучше текущего и если смещение - в сторону профита
            // (при первом поджатии, от курса открытия, новый стоплосс может быть лучше имеющегося, и в то же время ниже 
            // курса открытия (если dBid ниже последнего) 
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
                //---- Если стоплосс выше курса открытия, то тралим "от курса открытия"
                if (OrderOpenPrice() < OrderStopLoss())
                {
                    ld_NextMove = NDD (FF_coeff * (OrderOpenPrice() - (dAsk + ld_Spread)));                 
                    fd_NewSL = NDD (OrderOpenPrice() - ld_NextMove);
                }
                //---- Если стоплосс нижу курса открытия, тралим от стоплосса
                else
                {
                    ld_NextMove = NDD (FF_coeff * (OrderStopLoss() - (dAsk + ld_Spread)));
                    fd_NewSL = NDD (OrderStopLoss() - ld_NextMove);
                }                  
            }
            //---- SL перемещаем только в случае, если новый стоплосс лучше текущего и если смещение - в сторону профита
            if (ld_NextMove > 0)
            {return (true);}
        }               
    }
//----
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| ТРЕЙЛИНГ KillLoss                                                                 |
//| Применяется на участке лоссов. Суть: стоплосс движется навстречу курсу со ско-    |
//| ростью движения курса х коэффициент (SpeedCoeff). При этом коэффициент можно      |
//| "привязать" к скорости увеличения убытка - так, чтобы при быстром росте лосса     |
//| потерять меньше. При коэффициенте = 1 стоплосс сработает ровно посредине между    |
//| уровнем стоплосса и курсом на момент запуска функции, при коэфф.>1 точка встречи  |
//| курса и стоплосса будет смещена в сторону исходного положения курса, при коэфф.<1 |
//| - наоборот, ближе к исходному стоплоссу.                                          |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool KillLoss (int fi_Ticket, double& fd_NewSL)
{
    double ld_StopPriceDiff, // расстояние (пунктов) между курсом и стоплоссом
           ld_ToMove,        // кол-во пунктов, на которое следует переместить стоплосс
           ld_curMove, ld_newSL, ld_Price, ld_LastPriceDiff;
    string ls_Name;
    int    li_cmd;
//----
    //---- Текущее расстояние между курсом и стоплоссом
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
    //---- Проверяем, если тикет новый, запоминаем текущее расстояние между курсом и стоплоссом
    if (!GlobalVariableCheck (ls_Name))
    {
        GlobalVariableSet (ls_Name, ld_StopPriceDiff);
        return (false);
    }
    else
    {ld_LastPriceDiff = GlobalVariableGet (ls_Name);}
    //---- Итак, у нас есть коэффициент ускорения изменения курса
    // на каждый пункт, который проходит курс в сторону лосса, 
    // мы должны переместить стоплосс ему на встречу на fd_SpeedCoeff раз пунктов
    // (например, если лосс увеличился на 3 пункта за тик, fd_SpeedCoeff = 1.5, то
    // стоплосс подтягиваем на 3 х 1.5 = 4.5, округляем - 5 п. Если подтянуть не 
    // удаётся (слишком близко), ничего не делаем.          
        
    //---- Кол-во пунктов, на которое приблизился курс к стоплоссу с момента предыдущей проверки (тика, по идее)
    ld_ToMove = (ld_LastPriceDiff - ld_StopPriceDiff) / Point;
        
    //---- Записываем новое значение, но только если оно уменьшилось
    if (ld_StopPriceDiff + NDPm (TrailStep) < ld_LastPriceDiff)
    {GlobalVariableSet (ls_Name, ld_StopPriceDiff);}
        
    //---- Дальше действия на случай, если расстояние уменьшилось (т.е. курс приблизился к стоплоссу, убыток растет)
    if (ld_ToMove >= TrailStep)
    {
        ld_ToMove = NDPm (MathRound (ld_ToMove * SpeedCoeff));
        if (OrderType() == OP_BUY) {li_cmd = 1;} else {li_cmd = -1;}
        //---- Стоплосс, соответственно, нужно также передвинуть на такое же расстояние, но с учетом коэфф. ускорения
        ld_curMove = li_cmd * (ld_Price - (OrderStopLoss() + li_cmd * ld_ToMove));
        fd_NewSL = OrderStopLoss() + li_cmd * ld_ToMove;
        return (true);
    }
    return (false);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//| ТРЕЙЛИНГ ПИПСОВОЧНЫЙ (для пипсовки)                                               |
//| Применяется для пипсовки, когда не известен тэйк и хочется взять по-максимуму.    |
//| Берём промежуток времени Period_Average и расчитываем средний размер свечи - это  |
//| будет условным тэйком (УТ). При достижении ценой половины УТ, переводим в Без-    |
//| Убыток. А затем применяем "удавку". При достижении ценой условного тэйка,         |
//| "удлиняем" его в 1.5 раза.                                                        |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
bool TrailPips (int fi_Ticket, double& fd_NewSL)
{
    double ld_VirtTP, ld_TrailStop = 0.0, ld_Price;
    string ls_Name = StringConcatenate (fi_Ticket, "_#VirtTP");
    int    li_cmd;
    //---- Получаем виртуальный Тэйк
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
        //---- Увеличиваем виртуальный тэйк
        if (ld_Price >= ld_VirtTP)
        {
            ld_VirtTP += ((ld_VirtTP - OrderOpenPrice()) / 2);
            GlobalVariableSet (ls_Name, ld_VirtTP);
        }
        //---- Рассчитываем TrailStop - расстояние от виртуального стопа до цены
        for (int li_int = 4; li_int >= 2; li_int--)
        {
            if ((ld_VirtTP - OrderOpenPrice()) / li_int >= ld_VirtTP - ld_Price)
            {
                //---- При прохождении ценой половины пути до цели, ставим виртуальный БУ
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
        //---- Увеличиваем виртуальный тэйк
        if (ld_Price <= ld_VirtTP)
        {
            ld_VirtTP -= ((OrderOpenPrice() - ld_VirtTP) / 2);
            GlobalVariableSet (ls_Name, ld_VirtTP);
        }
        //---- Рассчитываем TrailStop - расстояние от виртуального стопа до цены
        for (li_int = 4; li_int >= 2; li_int--)
        {
            if ((OrderOpenPrice() - ld_VirtTP) / li_int >= ld_Price - ld_VirtTP)
            {
                //---- При прохождении ценой половины пути до цели, ставим виртуальный БУ
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
//       Проверяем условие ни минимальную прибль по ордеру.                           |
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
//|        Просчитываем среднее значение размера свечи за означенный период           |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
double fGet_AverageCandle (string fs_Symbol,         // Символ
                           int fi_Period,            // Период
                           bool fb_IsCandle = false) // считаем свечу?
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
    //Print ("Time[", li_cnt_Bar, "] = ", TimeToStr (ldt_Begin), "; Свеча = ", DS0 (ld_AVERAGE / bd_Point));
//----
    return (ld_AVERAGE);
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|            Подчищаем перед началом тестирования все GV-переменные                 |
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
//|            Подчищаем использованные GV-переменные                                 |
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
        //---- Выделяем рабочий тикет
        OrderSelect (li_Ticket, SELECT_BY_TICKET, MODE_TRADES);
    }
//---- 
}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|  UNI:      Получаем номер периода графика                                         |
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
//|     Пишем Log-файл                                                                |
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
    //---- Имя лог файла определяем один раз в сутки
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
//|        Функция, нормализации значения double до Digit                             |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
double NDD (double v) {return (NormalizeDouble (v, Digits));}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        Функция, перевода значения из double в string c нормализацией по Digit     |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
string DSDm (double v) {return (DoubleToStr (v, Digits));} 
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        Функция, перевода значения из double в string c нормализацией по 0         |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
string DS0 (double v) {return (DoubleToStr (v, 0));} 
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
//|        Функция "нормализации" значения по Point                                   |
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+
double NDPm (double v) {return (v * Point);}
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII+

