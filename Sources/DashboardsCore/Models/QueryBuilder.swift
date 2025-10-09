import Foundation

struct QueryBuilder {
    static func build(from widgetQuery: WidgetQuery) -> Query {
        return Query(
            view: widgetQuery.view,
            limit: widgetQuery.limit,
            table: widgetQuery.table,
            fields: widgetQuery.fields,        
            filter: widgetQuery.filter,
            groupBy: widgetQuery.groupBy ?? [],
            orderBy: widgetQuery.orderBy ?? [],
            distinctOn: widgetQuery.distinctOn ?? [],
            joinSubquery: widgetQuery.joinSubquery
        )
    }
}
