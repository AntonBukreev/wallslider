#include <QCoreApplication>
#include <windows.h>
#include <iostream>
using namespace std;

LPWSTR CharToLPWSTR(LPCSTR char_string)
{
    LPWSTR res;
    DWORD res_len = MultiByteToWideChar(1251, 0, char_string, -1, NULL, 0);
    res = (LPWSTR)GlobalAlloc(GPTR, (res_len + 1) * sizeof(WCHAR));
    MultiByteToWideChar(1251, 0, char_string, -1, res, res_len);
    return res;
}

int main(int argc, char *argv[])
{
    LPWSTR img = CharToLPWSTR(argv[1]);

       int result = SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, img, SPIF_UPDATEINIFILE);
       if(result)
           cout << "Wallpaper set successfully!";
       else
           cout << "Error: " << GetLastError();
       cin >> result;

    return 0;
}


