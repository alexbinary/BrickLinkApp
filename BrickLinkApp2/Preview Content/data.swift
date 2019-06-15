
import Foundation



let dummyOrdersStore = makeDummyOrdersStore()

func makeDummyOrdersStore() -> OrdersStore {

    let url = Bundle.main.url(forResource: "orders", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let response: APIResponse<[Order]> = data.decode()
    
    let store = OrdersStore()
    store.orders = response.data
    return store
}
