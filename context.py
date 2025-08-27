import os, random, argparse
API_KEYS = [
    "AIzaSyCiB3gW0QzmUBMCZ3c6MVvqFEKrxZFmeGc", "AIzaSyDVo8DNaP83QHLv7xZdVnGaQZeqvPeO2z4", "AIzaSyBUeFox8lojrsoIAoGB7uUf9jQgR06lZTY", "AIzaSyCLq9nq4pHMyERQQw-Mf0zo1LqBPwnGoLA",
    "AIzaSyCF5OR_u-5QwwFdw7tqCqYRbmjoGRb72a4", "AIzaSyDh2NhmdX1k2CBHr8ihUg1ZxOUcjgfK8Xs", "AIzaSyDmdDqR7m09wpsSPPL5NJZcrifHbyZnmaA", "AIzaSyAjzxCdU5DveCs5gA3ntOJu9x4_d83yaJo",
    "AIzaSyDDdMpudGwbZXSOpwqs-xwfUglk_XzKBnI", "AIzaSyA-TegrDzMivFPkx7togiszk3uHh4_651k", "AIzaSyB6DQktiSgaaXRd_dv-SerAA2JdR3jpQEs", "AIzaSyADTMylO4XBu3wbVMkOrfcmFY8n361SnW0",
    "AIzaSyCO9cBcelNVDRzKCdtSXyoaA31Dx_-sKvI", "AIzaSyDsgutKPdbruqGF68NEPp6dq8aQo6Q9of0", "AIzaSyCDTO25xBuTIiR2eP9oTc6qblkpS-HCctA", "AIzaSyDomV8uOYok34Sl72XByhDGCVxyPIe9oyk",
    "AIzaSyCfRLuYSoR99hXCa86U3XZonT-Rq8lkKXM", "AIzaSyCJCIwBsd30BD1pLlV7AWhDdyINob1Sjb4", "AIzaSyDBdczglnZ07jlEb7VmA--R9Q2bcNei8AQ", "AIzaSyAl3hROouskb-pR2TtedImaU_kcfkxhYlU",
    "AIzaSyAvzQwwSRPgWWIEc4-yQ0klz3gXQDc08o8", "AIzaSyBzOLCWZ53THcjxzen4w7oAyvdO1Wjopw4", "AIzaSyC8niz7TpRuwFE57Rx1eMxTE5LKqNvhKNo", "AIzaSyD3jPa14QMrHyLS42KGAVFedjuNoIIxymE",
    "AIzaSyBbfDvv77F7F0ThvnD-tkLZAwIipVIcyos", "AIzaSyAZfhrbJxO1GxoyoBKyyoYVJu-Wg4UwCd0", "AIzaSyDhhymbtN1OJ9Zu3i4XG7JxOA_3CYxGKQU", "AIzaSyAHdefmyzGj095HQHpJ1bmgur_GacXWdP4",
    "AIzaSyBDRp5VEfUpq1xr3pZfp0QFGsVJLdn8qqc", "AIzaSyACI1xjSWdnlpfnDu-AzaUx24ld80oXqfk", "AIzaSyB2FGD9w9Tmw8U9KNm1ZV6sl-JyVsQO_AM", "AIzaSyBQJPSoyGeX9ZFR6K-xgGqzKthz5kc03T4",
    "AIzaSyBP1jHtjvZHg3tBWmNoq4PePOOwEHbDDCY", "AIzaSyCTWbR2OIOI6-Oyr1wtUvLVrXnf6tpSsbQ", "AIzaSyCB6j6TnYNKx2Fgr-kLuVJt0ic1cCROBrc", "AIzaSyAMCwa74FBoU_X3f4FIX5aas_ggWDfedW4",
    "AIzaSyDZCa_OpAKQjblklcFz795NRTSg2F7nmD8"
]
def core(model: str):
    os.system("cls" if os.name == "nt" else "clear")
    ooooooooooooooooooooooo = random.choice(API_KEYS)
    os.environ["GEMINI_API_KEY"] = ooooooooooooooooooooooo
    try:
        os.system("cls" if os.name == "nt" else "clear")
        os.system(f"npx --yes --force '@google/gemini-cli@nightly' --show_memory_usage --model '{model}'")
    except Exception as e:
        print(e)
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="_________________________________")
    parser.add_argument("mode", choices=["p", "f"], help="_________________________")
    core("gemini-2.5-pro" if parser.parse_args().mode == "p" else "gemini-2.5-flash")