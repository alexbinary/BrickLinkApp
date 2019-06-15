
import Foundation



let testOrdersStore = makeTestOrdersStore()

func makeTestOrdersStore() -> OrdersStore {

    let url = Bundle.main.url(forResource: "orders", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let response: APIResponse<[Order]> = data.decode()
    let testOrders = response.data
    
    let store = OrdersStore()
    store.orders = testOrders
    return store
}
