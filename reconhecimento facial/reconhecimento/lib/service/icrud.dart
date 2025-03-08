abstract class ICRUDDao<T> {
  Future<void> inserir(T t);
  Future<int> atualizar(T t);
  Future<void> deletar(T t);
  Future<T> consultar(T t);
  Future<List<T>> listar();
}