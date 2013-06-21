
//#include <iostream>
//using namespace std;
//
///*---------------------
// *  hash table
// ----------------------*/
template <class T_ADD,class T_DAT>
class MemTable {
    public :

      MemTable() {}
      ~MemTable() {}

    private:
      typedef typename std::map<T_ADD,T_DAT> TMap;
      TMap m_map;

}

int main(int argc, char *argv[])
{
//  MemTable<unsigned int, unsigned int> m;
  return 0;
}

